# Dates And Time

Date and Time is a very tricky thing to get correct. Our solution is to avoid
timezones as much as possible. Luckily since most employees are working at a
physical location the time zones can generally be inferred. IE a location is 
in EST so saying 4pm the employee should know its 4PM est. 

Time zones come into play when we need to figure out when there is a next shift
or something happening relative to current server time. When this happens we
can convert the non-timezone dates and times into timezones based upon the
location they are working at.

### Date Storage

Dates are stored in YYYYMMDD format as integers. This gives us easily ability
to select dates based upon integer values. We want to avoid using ruby dates
and particular date_times as much as possible to prevent time zone bugs.

### Time Storage

Times are stored in minutes. IE noon is 720. Once again we get the ability to
quickly select times based on ruby values without going through the DateTime
class. To an employee 12pm is 12pm at that location. Most of the time the 
timezone is irrelevant to us.

Working With Time
======

There is module that provides many of the utilities you will need when working
with time in our application. [Source](/app/models/date_and_time)

#####  Get a time for a location

```ruby
  DateAndTime::LocationTime.for(location)
```
[Source](/app/models/date_and_time/location_time.rb)

##### Convert YYYYMMDD Format
```ruby
  DateAndTime::Parser.for("20170423")
```
[Source](/app/models/date_and_time/date_parser.rb)
