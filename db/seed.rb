
class Seed
    def self.seed_data
        a = Author.create(name: "Michael Scott")

        10.times do
            Tweet.create({content: Faker::TvShows::MichaelScott.quote, author_id: a.id})
        end

        # 5.times do
        #     Tweet.create({content: Faker::Quote.yoda, author: 'Yoda'})
        # end

        # 5.times do
        #     Tweet.create({content: Faker::Quote.matz, author: 'Matz'})
        # end
    end
end