USE world;

-- PARTE I:
drop table if exists country;
CREATE TABLE IF NOT EXISTS country (
    Code VARCHAR(3),
    PRIMARY KEY (Code),
    Name VARCHAR(250),
    Continent VARCHAR(52),
    Region VARCHAR(250),
    SurfaceArea INTEGER,
    IndepYear INTEGER,
    Population INTEGER,
    LifeExpectancy INTEGER,
    GNP INTEGER,
    GNPOId INTEGER,
    LocalName VARCHAR(250),
    GovernmentForm VARCHAR(250),
    HeadOfState VARCHAR(250),
    Capital INTEGER,
    Code2 VARCHAR(250)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

drop table if exists city;
CREATE TABLE IF NOT EXISTS city (
    ID INTEGER,
    PRIMARY KEY (ID),
    Name VARCHAR(250),
    CountryCode VARCHAR(250),
    Distric VARCHAR(250),
    Population BIGINT,
    CONSTRAINT `City_fk` FOREIGN KEY (`CountryCode`)
        REFERENCES `country` (`Code`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

drop table if exists countrylanguage;
CREATE TABLE IF NOT EXISTS countrylanguage (
    CountryCode VARCHAR(250),
    Language VARCHAR(250),
    PRIMARY KEY (CountryCode , Language),
    IsOfficial VARCHAR(250),
    Percentage DECIMAL(4,1),
    CONSTRAINT `CountryLanguage_fk` FOREIGN KEY (`CountryCode`)
        REFERENCES `country` (`Code`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

drop table if exists continent;
CREATE TABLE IF NOT EXISTS continent (
    ContinentName VARCHAR(250),
    PRIMARY KEY (ContinentName),
    Area INTEGER,
    Percentage DECIMAL,
    PopulusCity VARCHAR(250)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

ALTER TABLE `country` MODIFY COLUMN `Continent` varchar(52);
ALTER TABLE `country` ADD CONSTRAINT `ContinentOfCountry_fk` FOREIGN KEY (`Continent`) REFERENCES `continent` (`ContinentName`);

