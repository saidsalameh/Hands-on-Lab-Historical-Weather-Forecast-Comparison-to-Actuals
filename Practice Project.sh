#! /bin/bash

# Scenario :

# You've been tasked by your team to create an automated Extract, Transform, Load (ETL) process
# to extract daily weather forecast and observed weather data and load it into a live report to be
# used for further analysis

# Data source : to get data for Casablanca 
# curl wttr.in/casablanca

# Creating a text file called rx_poc.log
filename="rx_poc.log"
if [[ ! -f "$filename" ]]   # -f : if file exist and is a regular file 
then 
    touch $filename
    # Add  a header to the weather report 
    header=$(echo -e "year\tmonth\tday\tobs_temp\tfc_temp")
    echo $header >> $filename
fi

# make the Bash script executable 
# chmod u+x rx_poc.sh 


city="Casablanca"

# Scraping the weather information 
# curl -s wttr.in/$city?T --output weather_report.txt

# use the pipe | to chaine commande 
# use grep to filter the command 

obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*')

if [[ -n "$obs_temp" ]] 
then
    echo "The current Temperature of $city: $obs_temp"
else
    echo "Failed to retrieve temperature for $city."
fi

# Extract tomorrow's temperature forecast for noon, and store it in a shell variable called fc_temp
# tomorrow date :
tomorrow=$(date -d "tomorrow" "+%a %d %b")

fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep -m 1 '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')


if [[ -n "$fc_temp" ]]
then
    echo "The current Temperature of $tomorrow noon: $fc_temp"
else
    echo "Failed to retrieve temperature for $tomorrow noon."
fi


#Assign Country and City to variable TZ
TZ_Morocco-Casablanca='Morocco/Casablanca'

# Use command substitution to store the current day, month, and year in corresponding shell variables:
hour=$(TZ_Morocco-Casablanca='Morocco/Casablanca' date -u +%H) 
day=$(TZ_Morocco-Casablanca='Morocco/Casablanca' date -u +%d) 
month=$(TZ_Morocco-Casablanca='Morocco/Casablanca' date +%m)
year=$(TZ_Morocco-Casablanca='Morocco/Casablanca' date +%Y)

record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo $record>>$filename

# create a cron job to run the script everyday 
#crontab -e
#0 8 * * * /path/to/your/script.sh


