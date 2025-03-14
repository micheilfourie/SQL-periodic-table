#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

FIND_ELEMENT(){
  if [[ $1 =~ ^[0-9]+$ ]]; then
    CHECK_ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type 
                           FROM elements e 
                           JOIN properties p ON e.atomic_number = p.atomic_number 
                           JOIN types t ON p.type_id = t.type_id 
                           WHERE e.atomic_number = $1")
  else
    CHECK_ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
                           FROM elements e 
                           JOIN properties p ON e.atomic_number = p.atomic_number 
                           JOIN types t ON p.type_id = t.type_id 
                           WHERE e.symbol ILIKE '$1' OR e.name ILIKE '$1'")
  fi

  if [[ -z "$CHECK_ELEMENT" ]]; then
    echo "I could not find that element in the database."
  else
    echo "$CHECK_ELEMENT" | while IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

if [[ $1 ]]; then
  FIND_ELEMENT $1
else
  echo "Please provide an element as an argument."
fi





