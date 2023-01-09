#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
X=10

DISTINCT(){

MAIN_QUERY="select properties.atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, types.type from properties inner join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id"
 
if [[ $1 =~ ^[0-9]+$ ]]
then

  QUR=$($PSQL "$MAIN_QUERY WHERE elements.atomic_number=$1")
  PRINT_INFO $QUR
  
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then

  QUR=$($PSQL "$MAIN_QUERY WHERE elements.symbol='$1'")
  PRINT_INFO $QUR

else

  QUR=$($PSQL "$MAIN_QUERY WHERE elements.name='$1'")
  PRINT_INFO $QUR

fi

}

PRINT_INFO(){
  if [[ $1 ]]
  then
  IFS="|"; read AN AM MP BP SYM NAME TY  <<< $1
  INFORMATION $AN $AM $MP $BP $SYM $NAME $TY
  else
    echo -e "I could not find that element in the database."
  fi
}

INFORMATION(){
  echo -e "The element with atomic number $1 is $6 ($5). It's a $7, with a mass of $2 amu. $6 has a melting point of $3 celsius and a boiling point of $4 celsius."
}

if [[ $1 ]]
then
  DISTINCT $1
else
  echo -e "Please provide an element as an argument."
fi