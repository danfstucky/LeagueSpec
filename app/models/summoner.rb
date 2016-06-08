        require 'lol'
        class Summoner < ActiveRecord::Base
            
            
            
            attr_accessor :summoner_name
           
            def initialize(name)
                @summonerReq = Lol::SummonerRequest.new Rails.application.secrets.sulai_api_key, "na"
                @summoner_name=name ||= 'nautilus'
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
