module Openfoodfacts
  class User < Hashie::Mash

    class << self

      # Login
      #
      def login(user_id, password, locale: Openfoodfacts::DEFAULT_LOCALE)
        uri = URI("http://#{locale}.openfoodfacts.org/cgi/session.pl")
        params = {
          "jqm" => "1",
          "user_id" => user_id,
          "password" => password
        }

        response = Net::HTTP.post_form(uri, params)
        data = JSON.parse(response.body)

        if data['user_id']
          data.merge!(password: password)
          new(data)
        end
      end

    end

    # Login
    #
    def login(locale: Openfoodfacts::DEFAULT_LOCALE) # TODO Try others
      if user = self.class.login(self.user_id, self.password, locale: locale)
        self.name = user.name
        self
      end
    end

  end
end