interface Permission {
    id: number;
    type: 'player' | 'referee' | 'admin';
    flags: number;
}

interface City {
    id: number;
    name: string;
    state: string;
}

interface Account {
    id: number;
    email: string;
    password: string;
    created_on: Date;
    logged_on: Date;
    verified: boolean;
    token: number;
    permissions_id: number;
}

interface AccountPermission {
    permissions_id: number;
    accounts_id: number;
}

interface Team {
    id: number;
    cities_id: number | null;
    name: string;
    description: string;
}

interface Player {
    id: number;
    accounts_id: number;
    teams_id: number | null;
    first_name: string;
    last_name: string;
    full_name: string;
    birthday: Date;
    number: number;
    height: number;
    weight: number;
    wingspan: number;
    position: 'PG' | 'SG' | 'SF' | 'PF' | 'C';
}

interface TeamPlayer {
    teams_id: number;
    players_id: number;
}

interface Audit {
    id: number;
    time: Date;
    status: number;
    message: string;
}