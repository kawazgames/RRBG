# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

field = <<EOM.lines.map{|x| x.chomp.split(//).map{|x| x == '#'} }
##########
#..#..#..#
#......#.#
#...##...#
#..#..#..#
#..#..#..#
#........#
#.#.###..#
#...#....#
##########
EOM
stage = Stage.where(id: 1).first_or_create
field.each_with_index do |line, y|
  line.each_with_index do |row, x|
    if row
      type = Map::MAP_TYPE_WALL
    else
      type = Map::MAP_TYPE_NONE
    end
    map = Map.where(stage_id: stage.id, x: x, y: y).first_or_initialize(
      stage: stage,
      type: type,
      x: x,
      y: y
    )
    map.save!
  end
end

pt_max = 1001
pt_max.times.each do |pt_id|
  pt = HighScorePartition.where(id: (pt_id + 1)).first_or_initialize
  pt.min = pt_id * 1000
  pt.max = (((pt_id + 1) * 1000) - 1)
  pt.save!
end

# dummy user
User.create! do |u|
  u.sign_in_count = 0
  u.current_sign_in_at = "2013-01-27 04:25:24"
  u.last_sign_in_at = "2013-01-27 04:25:24"
  u.current_sign_in_ip = "192.168.0.1"
  u.last_sign_in_ip = "192.168.0.1"
end

Authentication.create! do |a|
  a.user_id = 1
  a.provider = "twitter"
  a.uid = "piBKQpd2e73Hceeknc39Hwizt_aa7dySPsEm9PeN"
  a.screen_name = 'kingdom'
  a.access_token = 'piBKQpd2e73Hceeknc39Hwizt_aa7dySPsEm9PeN'
  a.access_secret = 'piBKQpd2e73Hceeknc39Hwizt_aa7dySPsEm9PeN'
  a.bio = '菌NGDOM'
  a.image_url = 'images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end


User.create! do |u|
  u.sign_in_count = 2
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "221.333.222.111"
  u.last_sign_in_ip = "221.333.222.333"
end


User.create! do |u|
  u.sign_in_count = 3
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "221.333.222.111"
  u.last_sign_in_ip = "221.333.222.333"
end

User.create! do |u|
  u.sign_in_count = 4
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "221.333.222.111"
  u.last_sign_in_ip = "221.333.222.333"
end

User.create! do |u|
  u.sign_in_count = 5
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "384.983.333.221"
  u.last_sign_in_ip = "192.168.101.332"
end

User.create! do |u|
  u.sign_in_count =6
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "192.168.22.111"
  u.last_sign_in_ip = "999.333.444.555"
end

User.create! do |u|
  u.sign_in_count = 7
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "192.168.22.111"
  u.last_sign_in_ip = "999.333.444.555"
end

User.create! do |u|
  u.sign_in_count = 8
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "192.168.22.111"
  u.last_sign_in_ip = "999.333.444.555"
end

User.create! do |u|
  u.sign_in_count = 9
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "192.168.22.111"
  u.last_sign_in_ip = "999.333.444.555"
end


User.create! do |u|
  u.sign_in_count = 10
  u.current_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.last_sign_in_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  u.current_sign_in_ip = "192.168.22.111"
  u.last_sign_in_ip = "999.333.444.555"
end

Authentication.create! do |a|
  a.user_id = 11
  a.provider = "aa#{rand}"
  a.uid = 'a;lskejroawierjaksdjfiwerhjdsfhgiuert#{rand}'
  a.screen_name = "sccafold"
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end

Authentication.create! do |a|
  a.user_id = 2
  a.provider = "asssa#{rand}"
  a.uid = "ua;lskejroawierjakew5zkjhfgiue5sdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = '1992'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end

Authentication.create! do |a|
  a.user_id = 3
  a.provider = "aaranda#{rand}"
  a.uid = "ua;lskejroawierasdfiwehrhtjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'isekaf34'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://yahoo.com/'
  a.last_tid = '1293859618723'
end

Authentication.create! do |a|
  a.user_id = 4
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua;1290374jbxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr9'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end
Authentication.create! do |a|
  a.user_id = 5
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua;1290374jboawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr7'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end
Authentication.create! do |a|
  a.user_id = 6
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua;aiodfjoasd1290374jbcvi7zxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr8'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end
Authentication.create! do |a|
  a.user_id = 7
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua;1290374jb30849324cvi7zxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr109'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end
Authentication.create! do |a|
  a.user_id = 8
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua;1290374jbcvi7zxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr19'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end
Authentication.create! do |a|
  a.user_id = 9
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua1290374jbcvi7zxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr9'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end

Authentication.create! do |a|
  a.user_id = 10
  a.provider = "aaosidfweor#{rand}"
  a.uid = "ua1290374jbcvi7zxtlskejroawierjaksdjfiwerhjdsfhgiuert#{rand}"
  a.screen_name = 'yuggr9'
  a.access_token = 'asldkfjaieor'
  a.access_secret = 'lakjfsdlkjafda'
  a.bio = 'bio'
  a.image_url = '../images/dummy.png'
  a.web_url = 'http://google.com/'
  a.last_tid = '1293859618723'
end

Rank.create! do |r|
  r.rank = 1
  r.score = 10000000000
  r.user_id = 1
end

Rank.create! do |r|
  r.rank = 2
  r.score = 200000000
  r.user_id = 2
end

Rank.create! do |r|
  r.rank = 3
  r.score = 30000000
  r.user_id = 3
end

Rank.create! do |r|
  r.rank = 4
  r.score = 4000000
  r.user_id = 6
end

Rank.create! do |r|
  r.rank = 5
  r.score = 500000
  r.user_id = 6
end

Rank.create! do |r|
  r.rank = 6
  r.score =60000
  r.user_id = 6
end

Rank.create! do |r|
  r.rank = 7
  r.score = 7000
  r.user_id = 1
end

Rank.create! do |r|
  r.rank = 8
  r.score = 800
  r.user_id = 1
end

Rank.create! do |r|
  r.rank = 9
  r.score = 90
  r.user_id = 1
end

Rank.create! do |r|
  r.rank = 10
  r.score = 10
  r.user_id = 1
end

