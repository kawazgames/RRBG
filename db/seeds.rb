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
