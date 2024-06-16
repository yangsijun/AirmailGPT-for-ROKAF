CREATE DATABASE IF NOT EXISTS airmailgpt-for-rokaf;

USE airmailgpt-for-rokaf;
CREATE TABLE IF NOT EXISTS mail (
    sender_name varchar(10),
    sender_relationship varchar(10),
    sender_zip_code varchar(10),
    sender_address1 varchar(50),
    sender_address2 varchar(50),
    airman_name varchar(10),
    airman_birth varchar(10),
    title varchar(30),
    content varchar(1000),
    password varchar(10),
    success boolean,
    timestamp timestamp
);

create table airman (
    member_seq varchar(10),
    name varchar(20),
    birth varchar(10)
);