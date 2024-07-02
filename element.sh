#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

# statement to check whether argument has been included when running program
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    REQUEST=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE CAST(atomic_number AS VARCHAR) = '$1' OR symbol = '$1' OR name = '$1'")

# output when request doesnt exist in the database
  if [[ -z $REQUEST ]]
  then
    echo "I could not find that element in the database."

# using argument input to query all tables in the database for the full information about element 
  else
    read ATOMIC_NUMBER BAR SYMBOL BAR NAME <<< $REQUEST
    read TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT <<< $($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM types, properties WHERE atomic_number = $ATOMIC_NUMBER AND properties.type_id = types.type_id")

# output of the requested element
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
