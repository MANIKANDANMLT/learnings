#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != "year" ]];
    then 
    WINNER_TEAM=$($PSQL "select * from teams where name = '$WINNER'")
    if [[ -z $WINNER_TEAM ]]
    then
    INSERT_WINNER=$($PSQL "insert into teams(name) values('$WINNER')")
    echo inserted 
    fi

    OPPONENT_TEAM=$($PSQL "select * from teams where name = '$OPPONENT'")
    if [[ -z $OPPONENT_TEAM ]]
    then
    INSERT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND','$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS)")"
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
        echo Game data inserted Successfully!
    else
        echo Failed to insert game data!
    fi
  fi
done
