#! /bin/bash
if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."; exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
INPUT=$1

#Find the atomic number given the input
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;")
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';")
fi

if [[ -z $ATOMIC_NUMBER ]]
then
  echo "I could not find that element in the database."
else
  ELEMENT_DATA=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$ATOMIC_NUMBER'")

  echo $ELEMENT_DATA | while IFS=" |" read an name symbol type mass mp bp 
  do
   echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
  done
fi





