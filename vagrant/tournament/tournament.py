#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect(db='tournament'):    
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        db = psycopg2.connect("dbname=%s" % db)
        cursor = db.cursor()
        return db, cursor
    except:
        raise IOError('Error connecting to database %s' % db)
    return db, cursor


def deleteMatches():
    db, c = connect()
    query = "truncate matches cascade;"
    c.execute(query)
    db.commit()
    db.close()
    """Remove all the match records from the database."""


def deletePlayers():
    db, c = connect()
    query = "truncate players cascade;"
    c.execute(query)
    db.commit()
    db.close()
    """Remove all the player records from the database."""


def countPlayers():
    db, c = connect()
    query = "select count(*) from players;"
    c.execute(query)
    count = c.fetchall()[0][0]
    db.close()
    return count
    """Returns the number of players currently registered."""


def registerPlayer(name):
    db, c = connect()
    query = "insert into players (name) values (%s);"
    c.execute(query, (name, ))
    db.commit()
    db.close()
    """Adds a player to the tournament database.  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
    Args:
      name: the player's full name (need not be unique).
    """
    


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.
    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.
    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    db, c = connect()
    query = "select * from standings;"
    c.execute(query)
    list_standings = c.fetchall()
    db.close()
    print 'STANDINGS', list_standings
    return list_standings      


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.
    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    db, c = connect()
    query = "insert into matches (winner, loser) values (%s, %s);"
    c.execute(query, (winner, loser))
    db.commit()
    db.close()

 
 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    db, c = connect()
    query = "select * from standings order by num_matches desc, score desc;"
    c.execute(query)
    result = c.fetchall()
    db.close()
    list_pairs = []
    for i in range(len(result)):
        if (i%2 ==0):
            pair = (result[i][0], result[i][1], result[i+1][0], result[i+1][1])
            list_pairs.append(pair)
    return list_pairs


