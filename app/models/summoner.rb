    require 'lol'
    class Summoner < ActiveRecord::Base
        
        @@Summoner = Lol::SummonerRequest.new "833becde-d428-4d74-bd27-8418e1c0a33d", "na"
        
        attr_accessor :summoner_name
       
        def initialize(name)
            @summoner_name=name ||= 'ahri'
        end
        
        def getSummonerId
            
           return @@Summoner.by_name(summoner_name).first.id
            
        end
        
        
        def getSummonerProfileIconId
            
           return @@Summoner.by_name(summoner_name).first.profile_icon_id
            
        end
       
       def getSummonerLevel
            
           return @@Summoner.by_name(summoner_name).first.summoner_level
            
       end
       
       def getSummonerRevisionDate
            
           return @@Summoner.by_name(summoner_name).first.revision_date
            
       end
        
        def getSummonerRevisionDateString
            
           return @@Summoner.by_name(summoner_name).first.revision_date_str
            
        end
       
    end
