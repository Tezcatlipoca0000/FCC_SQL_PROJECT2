#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams;")

cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != "year" ]]
  then

    # Insert winner into teams if not found
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WIN == "INSERT 0 1" ]]
      then
        WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        echo inserted a new team: $WINNER with id: $WIN_ID
      fi
    fi

    # Insert opponent into teams if not found
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPP == "INSERT 0 1" ]]
      then
        OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        echo inserted a new team: $OPPONENT with id: $OPP_ID
      fi
    fi

    # insert into games table 

    echo $($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND');")
  fi
done