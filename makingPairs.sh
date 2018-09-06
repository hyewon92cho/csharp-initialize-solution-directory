#!/usr/bin/env bash

function convertASCII() {
  local ch=$1
  ch=$(printf "%d" "'$1")
  return $ch
}

function convertChar() {
  local num=$1
  num=$(printf %x $num)
  numChar=$(printf "\x$num")
  echo $numChar
}

function ToLower() {
  local ch=$1
  convertASCII $ch
  chNum=$?
  chNum=$((chNum+32))
  ch=$(convertChar $chNum)
  echo $ch
}

read -p 'person1 first name: ' person1FirstName
read -p 'person1 last name: ' person1LastName
read -p 'person1 email: ' person1Email
read -p 'person2 first name: ' person2FirstName
read -p 'person2 last name: ' person2LastName
read -p 'person3 email: ' person2Email

person1InitialFirst=${person1FirstName:0:1}
person1InitialFirst=$(ToLower $person1InitialFirst)

person1InitialSecond=${person1LastName:0:1}
person1InitialSecond=$(ToLower $person1InitialSecond)

person1Initial=${person1InitialFirst}${person1InitialSecond}

person2InitialFirst=${person2FirstName:0:1}
person2InitialFirst=$(ToLower $person2InitialFirst)

person2InitialSecond=${person2LastName:0:1}
person2InitialSecond=$(ToLower $person2InitialSecond)

person2Initial=${person2InitialFirst}${person2InitialSecond}

touch ~/.pairs
echo pairs: >> ~/.pairs
echo ' '$person1Initial: $person1FirstName $person1LastName >> ~/.pairs
echo ' '$person2Initial: $person2FirstName $person2LastName >> ~/.pairs
echo email: >> ~/.pairs
echo ' '$person1Initial: $person1Email >> ~/.pairs
echo ' '$person2Initial: $person2Email >> ~/.pairs
