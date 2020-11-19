class Tweet 

    attr_accessor :content, :author_id, :id

    def initialize(attr_hash={})
        #is NOT responsible for sending attributes to the db
        # is resonsible for assign the attributes that we get FROM the db to objects
        attr_hash.each do |key, value|
            if self.respond_to?("#{key.to_s}=")
                self.send("#{key.to_s}=", value) # send = call this method
            end
            #self.content=(value)
        end
        #{content: Faker::Quote.matz, author_id: 'Matz'}
    end

    def self.create(attr_hash={}) # empty here b/c default argument
        # instantiate a new tweet
        # save new tweet
        tweet = self.new(attr_hash) # not empty here b/c sending in argument
        tweet.save
    end

    def self.all
       array_of_hashes = DB[:conn].execute("SELECT * FROM tweets")
       array_of_hashes.collect do |hash|
         self.new(hash)
       end
    end

    def self.find(id)
        sql = "SELECT * from tweets WHERE tweets.id = ?"
        obj_hash = DB[:conn].execute(sql, id)[0]
        self.new(obj_hash)
    end

    def delete # delete one tweet, not all
        sql = "DELETE FROM tweets WHERE id = ?"
        DB[:conn].execute(sql, self.id) # we don't have an id variable, so it assumes it's a method, thus the self.id
        self # returns the tweet we just deleted
    end


    def save 
        # add the attr_accessor data to the db
        if !!self.id  
             # if it is already saved, update it 
             sql = <<-SQL 
                UPDATE tweets
                SET content = ?, author_id = ?
                WHERE id = ?;
             SQL
             DB[:conn].execute(sql, self.content, self.author_id, self.id)
        else
            # if it is not already saved, add to db
            sql = <<-SQL 
                INSERT INTO tweets (content, author_id) 
                VALUES (?,?)
            SQL
            DB[:conn].execute(sql, @content, self.author_id)
            @id = DB[:conn].last_insert_row_id
        end
        self
    end

    def self.create_table 
        # responsible for creating a class
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS tweets (
                id INTEGER PRIMARY KEY,
                content TEXT,
                author_id INTEGER
            )
        SQL

        DB[:conn].execute(sql)
    end

    def author
        # want to return author obj. need to use author id
        Author.find(self.author_id) 
    end
end