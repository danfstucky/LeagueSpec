        require 'lol'
        class Summoner < ActiveRecord::Base
            
            
            
            attr_accessor :summoner_name, :summoner
           
            def initialize(name)
                @summonerReq = Lol::SummonerRequest.new "833becde-d428-4d74-bd27-8418e1c0a33d", "na"
                @summoner_name=name ||= 'ahri'
                @summonerObj = getSummonerObject
            end
            
            def getSummonerObject
                
               return @summonerReq.by_name(summoner_name).first
                
            end
            
            def getSummonerId
                
               @summonerObj.id
                
            end
            
            
            def getSummonerProfileIconId
                
                @summonerObj.profile_icon_id
                
            end
           
           def getSummonerLevel
                
                @summonerObj.summoner_level
                
           end
           
           def getSummonerRevisionDate
                
                @summonerObjrevision_date
                
           end
            
            def getSummonerRevisionDateString
                
                @summonerObj.first.revision_date_str
                
            end
           
        end
