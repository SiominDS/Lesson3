# База объектов в системе.
# Нужна для предотвращения создания дубликатов.

@@trains = Hash.new
@@stations = Array.new
@@routes = Hash.new

# Поезд - основной и наиболее детализированный объект в системе.
# Именно через него мы будем формировать большинство запросов в системе.
class Train
  def initialize (number, type, car_quantity)
    if @@trains[number] == nil
      @number = number
      @train = {type: type, car_quantity: car_quantity, speed: 0, route_name: 'Depot', current_station: 'none'}
      @@trains[@number] = @train
    else
      puts "Duplicate train"
    end
  end

  def set_speed (newspeed)
      @train[:speed] = newspeed
      puts "New speed is #{@train[:speed]}"
  end

  def full_stop
    @train[:speed] = 0
    puts "New speed is #{@train[:speed]}"
  end

  def set_car_quantity (operation)
    if @train[:speed] !=0
      puts "The train is on the move"
    else
      @train[:car_quantity] -= 1 if operation == 'decrease'
      @train[:car_quantity] += 1 if operation == 'increase'
    end

    puts "New car quantity is #{@train[:car_quantity]}"
  end

    def assign_to_route (route_name)
      if @@routes.include?(route_name) == false
        puts "Route does not exist"
      else
        @train[:route_name] = route_name
        puts "Current route is #{route_name}"
        stations = @@routes[route_name]
        @train[:current_station] = stations[0].get_station_name
        puts "Current station is #{stations[0].get_station_name}"
      end
    end

    def route_movement (direction)
      route = @@routes[@train[:route_name]]
      station_name = @train[:current_station]
      current_index = route.index(station_name)
      previous_index = current_index.to_i - 1
      future_index = current_index.to_i + 1
        if direction == 'forward' &&  route[future_index]!= nil
          @train[:current_station] = route[future_index]
        end

        if direction == 'backwards' && route[previous_index] != nil
          @train[:current_station] = route[previous_index]
        end

        puts "New station is #{@train[:current_station].get_station_name}"
      end
end

# Станция сама по себе может быть только одна.
# Однако она может входить в разные маршруты.
# Маршрут можно создавать на основе существующих станций
# или создавать новые при добавлении в маршрут.
class Station
  def initialize (station_name)
      @station_name = station_name

    if @@stations.include?(@station_name) == false
       puts @station_name
       @@stations << @station_name

    else
      puts "Duplicate station"
    end
  end

  def get_station_name
#    puts @station_name
    return @station_name
  end

  def train_arrival (number)
    @@trains[number][:station_name] = @station_name
    puts "Train #{number} arrived to #{@station_name}"
  end

  def train_departure (number)
   @@trains[number][:station_name] = nil if @@trains[number][:station_name] == @station_name
  end

  def trains_here_all
    @@trains.each do |number,station_name|
      puts @@trains if @@trains[number][:station_name] == @station_name
    end
  end

  def trains_type_here (type)
    @@trains.each do |number,station_name|
      if @@trains[number][:station_name] == @station_name && @@trains[number][:type] == type
        puts number
      end
    end
  end
end

# Этот класс представляет собой массив с именами станций. Ключом в хeше маршрутов является имя самого маршрута.
class Route
  def initialize (first_station, last_station)
      puts @route_name = "#{first_station.get_station_name} - #{last_station.get_station_name}"

      if @@routes.include?(@route_name) == true
        puts "Duplicate route"
      else
        @route = []
        @route.unshift(first_station)
        @route.push(last_station)
        @@routes[@route_name] = @route
      end
  end

  def get_route_name
    return @route_name
  end

  def get_station_names
    @route.each_index do |value|
      puts @route[value].get_station_name
    end
  end

  def get_stations(index)
    return @route[index]
  end

  def get_station_index(station_name)
    @route.each_index do |value|
      if @route[value] == station_name
        return value
      end
    end
  end

  def set_station (station_name)
    @route << station_name
#    puts @route
    station_temp = @route[-2]
    @route[-2] = @route[-1]
    @route[-1] = station_temp
#    puts @route
  end

  def delete_station (station_name)
    @route.each_index do |value|
      if @route[value].get_station_name == station_name && (value != 0 || value != @route.size-1)
         @route.delete_at(value)
       end
     end
  end
end

t1 = Train.new(578,'passenger',8)
t1.set_speed(45)
t1.full_stop
t1.set_car_quantity('increase')
s1 = Station.new('Chuhlinka')
s2 = Station.new('Moskva')
s3 = Station.new('Petushki')
s4 = Station.new('Petushki')
s5 = Station.new('Kuskovo')
s6 = Station.new('Reutovo')
s7 = Station.new('Drezna')
s1.train_arrival(578)
#t1 = Train.new(578,'passenger',8)
s1.trains_here_all
s1.trains_type_here('passenger')
r1 = Route.new(s2,s3)
r1.set_station(s1)
r1.get_station_index('Moskva')
r1.get_station_names
r1.delete_station('Chuhlinka')
r1.get_station_names
r1.set_station(s1)
r1.set_station(s5)
r1.set_station(s6)
r1.set_station(s7)
r1.get_station_names
t1.assign_to_route('Moskva - Petushki')
t1.route_movement('forward')
