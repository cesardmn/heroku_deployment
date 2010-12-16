module HerokuDeploy
  class Git
    class << self
      def current_version
        `git show HEAD | head -n 1`.split(" ").last.strip
      end
      
      def push
        system %(git push >/dev/null 2>&1)
      end
      
      def pull
        system %(git pull >/dev/null 2>&1)
      end
      
      def push_remote
        create_heroku_remote
        system %(git push #{HerokuDeploy::Config.remote} master)
      end
      
      def pull_remote
        system %(git pull #{HerokuDeploy::Config.remote} master >/dev/null 2>&1)
      end
      
      def commit
        system %(git commit -m "Heroku deployment" -o #{HerokuDeploy::Config.commit_files.join(" ")} >/dev/null 2>&1)
      end
      
      def create_heroku_remote
        remote = HerokuDeploy::Config.remote
        app = HerokuDeploy::Config.app
        if `git remote | grep #{remote}`.to_s == ""
          puts "Couldn't find '#{remote}' remote, added one now"
          system %(git remote add #{remote} git@heroku.com:#{app}.git)
        end
      end
    end
  end
end