DROP DATABASE IF EXISTS tournament_dev CASCADE;

CREATE DATABASE IF NOT EXISTS tournament_dev;

USE DATABASE tournament_dev;

CREATE TYPE IF NOT EXISTS position_enum AS ENUM ('PG', 'SG', 'SF', 'PF', 'C');
CREATE TYPE IF NOT EXISTS account_enum AS ENUM ('player', 'referee', 'admin');

CREATE TABLE IF NOT EXISTS permissions (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    type account_enum NOT NULL DEFAULT 'player',
    flags BIT(8) NOT NULL DEFAULT B'00000000'
);

CREATE TABLE IF NOT EXISTS cities (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    state TEXT NOT NULL,
    INDEX cities_name (name)
);

CREATE TABLE IF NOT EXISTS accounts (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT now(),
    logged_on TIMESTAMP NOT NULL,
    verication_code TEXT NOT NULL UNIQUE,
    permissions_id BIGINT NOT NULL UNIQUE REFERENCES permissions (id) ON DELETE CASCADE,
    INDEX accounts_email (email),
    INDEX accounts_verication_code (verication_code)
);

CREATE TABLE IF NOT EXISTS accounts_permissions (
    permissions_id BIGINT NOT NULL REFERENCES permissions (id) ON DELETE CASCADE,
    accounts_id BIGINT NOT NULL UNIQUE REFERENCES accounts (id) ON DELETE CASCADE,
    PRIMARY KEY (permissions_id, accounts_id)
);

CREATE TABLE IF NOT EXISTS recoveries (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    accounts_id BIGINT NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    created_on TIMESTAMP NOT NULL DEFAULT now(),
    recovered_on TIMESTAMP DEFAULT NULL,
    verication_code TEXT NOT NULL UNIQUE,
    INDEX accounts_verication_code (verication_code)
);

CREATE TABLE IF NOT EXISTS categories (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    name TEXT NOT NULL,
    INDEX categories_name (name)
);

CREATE TABLE IF NOT EXISTS teams (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    cities_id BIGINT DEFAULT NULL REFERENCES cities (id) ON DELETE CASCADE,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT now(),
    INDEX teams_name (name)
);

CREATE TABLE IF NOT EXISTS players (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    accounts_id BIGINT NOT NULL UNIQUE REFERENCES accounts (id) ON DELETE CASCADE,
    teams_id BIGINT DEFAULT NULL REFERENCES teams (id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    full_name TEXT AS (CONCAT(first_name, ' ', last_name)) STORED,
    birthday TIMESTAMP NOT NULL,
    number SMALLINT NOT NULL,
    height SMALLINT NOT NULL,
    weight SMALLINT NOT NULL DEFAULT 0,
    wingspan SMALLINT NOT NULL DEFAULT 0,
    position position_enum NOT NULL,
    UNIQUE (teams_id, number),
    INDEX players_number (number)
);

CREATE TABLE IF NOT EXISTS teams_players (
    teams_id BIGINT NOT NULL REFERENCES teams (id) ON DELETE CASCADE,
    players_id BIGINT NOT NULL UNIQUE REFERENCES players (id) ON DELETE CASCADE,
    PRIMARY KEY (teams_id, players_id)
);

CREATE TABLE IF NOT EXISTS audits (
    id BIGINT NOT NULL UNIQUE DEFAULT unique_rowid() PRIMARY KEY,
    time TIMESTAMP NOT NULL DEFAULT NOW(),
    status SMALLINT NOT NULL DEFAULT 0,
    message TEXT NOT NULL
);