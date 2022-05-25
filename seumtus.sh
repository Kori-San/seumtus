#!/bin/bash

# [Vars]
# -> Getting the path of the script and then getting the directory of the script.
path=$(readlink -f "$0") && path=$(dirname "${path}")
words_path="${path}/data/word_list" 
# -> Getting a random line from the word list and then converting it to lowercase.
line_number=$(shuf -i 1-"$(wc -l "${words_path}" | cut -d ' ' -f1)" -n 1)
word=$( sed -n "${line_number}p" "$words_path" ) && word="${word,,}"
# -> Setting the attempts to 0 and the max attempts to 10.
attempts="0"
max_attempts="10"
# -> Creating a string with the same length as the word, but with the first letter and the rest of the letters replaced by @.
for (( i = 0; i < ${#word}; i++ )); do
    letter="${word:$i:1}"
    if [ ${i} -eq 0 ]; then
        user_best+="${letter}"
    else
        user_best+="@"
    fi
done

# [Functions]
# -> It's replacing the @ by the letter if the letter is correct.
update_best(){
    for (( i = 0; i <= ${#word}; i++ )); do
        letter="${word:$i:1}"
        user_letter="${user_word:$i:1}"
        if [ "${user_letter,,}" = "${letter,,}" ] ; then
            user_best=$(echo "$user_best" | sed "s/./${letter}/$(( i + 1))")
        fi
    done
}

# -> It's printing the word with the correct letters in green and the wrong letters in red.
pretty_printd(){
    for (( i = 0; i < ${#word}; i++ )); do
        # ~> It's getting the letter from the word, the letter from the user_word and the letter from the user_best.
        letter="${word:$i:1}"
        user_letter="${user_word:$i:1}"
        user_better="${user_best:$i:1}"
        # ~> It's printing the word with the correct letters in green and the wrong letters in red.
        if [ "${user_better,,}" = "${letter,,}" ] ; then
            tput setab 2
            printf "%s" "${letter^^}"
        elif [[ *"${user_letter,,}"* == "${word}" ]] ; then
            tput setab 3
            printf "%s" "${letter^^}"
        else
            printf "*"
        fi
        # ~> It's resetting the color.
        tput sgr0
    done
    # ~> It's printing a carriage return.
    printf "\r"
}

# -> It's printing the word with the correct letters in green and the wrong letters in red.
pretty_printf(){
    # ~> It's printing a carriage return.
    printf "\r"
    for (( i = 0; i < "${#word}"; i++ )); do
        # ~> It's getting the letter from the word, the letter from the user_word and the letter from the user_best.
        letter="${word:$i:1}"
        user_letter="${user_word:$i:1}"
        # ~> It's printing the word with the correct letters in green and the wrong letters in red.
        if [ "${i}" -eq "0" ] || [ "${user_letter,,}" = "${letter,,}" ] ; then
            tput setab 2
            printf "%s" "${letter^^}"
        elif [[ "${word}"  == *"${user_letter,,}"* ]] ; then
            tput setab 3
            printf "%s" "${user_letter^^}"
        else
            tput setab 1
            printf "%s" "${user_letter^^}"
        fi
        # ~> It's resetting the color.
        tput sgr0
    done
}

# [Main]
# -> It's a loop that will run until the user_best is equal to the word or the attempts are greater than the max_attempts.
while : ; do
    # ~> It's replacing the @ by the letter if the letter is correct.
    update_best
    # ~> It's checking if the user_best is equal to the word or if the attempts are greater than the max_attempts.
    if [ "${user_best,,}" = "${word,,}" ] || [ "${attempts}" -gt "${max_attempts}" ]; then
        break
    fi
    # ~> It's printing the number of attempts left, printing the word with the correct letters in green and 
    #    the wrong letters in red, reading the user input and then printing the word with the correct letters
    #    in green and the wrong letters in red.
    attempts=$(( attempts + 1 ))
    printf "You have %d attempts left\n" "$(( 11 - attempts ))"
    pretty_printd
    read -r user_word > /dev/null
    pretty_printf
    printf "\n\n"
done

# -> It's printing the word and then it's printing congratulations
#    if the user_best is equal to the word or try again if it's not.
printf "The word was %s, " "${word^^}"
if [ "${user_best,,}" = "${word,,}" ] ; then
    printf "congratulations !\n"
else
    printf "try again !\n"
fi