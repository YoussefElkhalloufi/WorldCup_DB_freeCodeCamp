#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 
  if [[ $YEAR != year ]]
  then
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name ='$OPPONENT'")

    if [[ -z $TEAM_ID_WINNER ]]
    then
        INSERT_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$WINNER')")

        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
          echo INSERTED INTO TEAMS, $WINNER
        fi

    fi

    if [[ -z $TEAM_ID_OPPONENT ]] 
    then
      INSERT_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$OPPONENT')")

      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo INSERTED INTO TEAMS, $OPPONENT
      fi 
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do

  if [[ $YEAR != year ]]
  then

    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name ='$OPPONENT'")

     INSERT_GAMES_RESULT=$($PSQL "INSERT INTO GAMES (year, round, winner_goals, opponent_goals, opponent_id, winner_id) values ($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $TEAM_ID_OPPONENT, $TEAM_ID_WINNER)")

    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo GAME INSERTED, $WINNER VS $OPPONENT.
    fi

  fi
done