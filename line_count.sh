#code inspired from: https://unix.stackexchange.com/questions/260630/how-do-you-list-number-of-lines-of-every-file-in-a-directory-in-human-readable-f author: malyy

total=0
find $PWD -type f -name "*.dart" | while read FILE; do
     #you see use grep instead wc ! for properly counting
     count=$(grep -c ^ < "$FILE")
     echo "$FILE has $count lines"
     let total=total+count #in bash, you can convert this for another shell
done
echo TOTAL LINES COUNTED:  $total
find $PWD -type f -name "*.py" | while read FILE; do
     #you see use grep instead wc ! for properly counting
     count=$(grep -c ^ < "$FILE")
     echo "$FILE has $count lines"
     let total=total+count #in bash, you can convert this for another shell
done
echo TOTAL LINES COUNTED:  $total
