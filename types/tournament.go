package main

import "time"

type Permission struct {
	ID    int64
	Type  string
	Flags int
}

type City struct {
	ID    int64
	Name  string
	State string
}

type Account struct {
	ID            int64
	Email         string
	Password      string
	CreatedOn     time.Time
	LoggedOn      time.Time
	Verified      bool
	Token         int64
	PermissionsID int64
}

type AccountPermission struct {
	PermissionsID int64
	AccountsID    int64
}

type Team struct {
	ID          int64
	CitiesID    int64
	Name        string
	Description string
}

type Player struct {
	ID         int64
	AccountsID int64
	TeamsID    int64
	FirstName  string
	LastName   string
	FullName   string
	Birthday   time.Time
	Number     int
	Height     int
	Weight     int
	Wingspan   int
	Position   string
}

type TeamPlayer struct {
	TeamsID   int64
	PlayersID int64
}

type Audit struct {
	ID      int64
	Time    time.Time
	Status  int
	Message string
}
