#! /bin/bash

PSQL="psql  -U freecodecamp --dbname=periodic_table -t -c"

PROMPT(){
  #TAKES ATOMIC NUM AS PARAM AND PROMPTS IT
   GET_PROPERTIES="$($PSQL "SELECT * FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$1")"
  #echo "PROMPT: $GET_PROPERTIES"
  echo $GET_PROPERTIES | while IFS=" " read TYPE_ID BAR ATOMIC_NUMBER BAR MASS BAR MELT BAR BOIL BAR TYPE 
  do

  echo "The element with atomic number $1 is $5 ($3). It's a $TYPE, with a mass of $MASS amu. $5 has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
}

SEARCH() {
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else 

  #eger sayıysa;
  if [[ $1 =~ [0-9]+ ]]
  then
    # query 
    QAN="$($PSQL "select * from elements where atomic_number=$1 ")"

    if [[ -z $QAN ]]
      then
      #bulunamadıysa bilgilendir
        echo "I could not find that element in the database."

      #bulunduysa neticelendir
      else
        PROMPT $QAN
    fi
  #eger stringse;
  else
    #query symbol
      QSYM="$($PSQL "select * from elements where symbol='$1' ")"
      if [[ -z $QSYM ]]
      then
      #sym bulunamadıysa query name
        QNAME="$($PSQL "select * from elements where name='$1' ")"
        #qname bulunduysa neticelendir
        if [[ -z $QNAME ]]
        then
          #BUNDA DA YOKSA SORRY BOI
          echo -e "I could not find that element in the database."
        
        else 
          PROMPT $QNAME
        fi
      else
      #FOUND BY QSYM
        PROMPT $QSYM
        
    fi
  fi
fi

}

SEARCH $1
