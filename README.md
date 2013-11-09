POC of sequel migration bug in sqlite

## Symptom

When adding a foreign key to an existing column, UNIQUE constraints are lost on that table


## Output

```
[sequelbug](master)$ sequel sqlite:/// -E -m migrations/
I, [2013-11-08T18:17:34.805466 #20295]  INFO -- : (0.000473s) PRAGMA foreign_keys = 1
I, [2013-11-08T18:17:34.805774 #20295]  INFO -- : (0.000072s) PRAGMA case_sensitive_like = 1
I, [2013-11-08T18:17:34.814067 #20295]  INFO -- : (0.000270s) SELECT sqlite_version() LIMIT 1
I, [2013-11-08T18:17:34.815056 #20295]  INFO -- : (0.000491s) CREATE TABLE IF NOT EXISTS `schema_info` (`version` integer DEFAULT (0) NOT NULL)
I, [2013-11-08T18:17:34.815546 #20295]  INFO -- : (0.000166s) SELECT * FROM `schema_info` LIMIT 1
I, [2013-11-08T18:17:34.816022 #20295]  INFO -- : (0.000125s) SELECT 1 AS 'one' FROM `schema_info` LIMIT 1
I, [2013-11-08T18:17:34.816507 #20295]  INFO -- : (0.000131s) INSERT INTO `schema_info` (`version`) VALUES (0)
I, [2013-11-08T18:17:34.817083 #20295]  INFO -- : (0.000157s) SELECT count(*) AS 'count' FROM `schema_info` LIMIT 1
I, [2013-11-08T18:17:34.817588 #20295]  INFO -- : (0.000158s) SELECT `version` FROM `schema_info` LIMIT 1
I, [2013-11-08T18:17:34.818984 #20295]  INFO -- : Begin applying migration version 1, direction: up
I, [2013-11-08T18:17:34.820073 #20295]  INFO -- : (0.000533s) CREATE TABLE `cats` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `name` varchar(255), `chip_id` varchar(255) NOT NULL UNIQUE, `owner_name` varchar(255))
I, [2013-11-08T18:17:34.820496 #20295]  INFO -- : (0.000119s) UPDATE `schema_info` SET `version` = 1
I, [2013-11-08T18:17:34.820666 #20295]  INFO -- : Finished applying migration version 1, direction: up, took 0.001666 seconds
I, [2013-11-08T18:17:34.820768 #20295]  INFO -- : Begin applying migration version 2, direction: up
I, [2013-11-08T18:17:34.821440 #20295]  INFO -- : (0.000277s) CREATE TABLE `people` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `name` varchar(255))
I, [2013-11-08T18:17:34.821820 #20295]  INFO -- : (0.000116s) UPDATE `schema_info` SET `version` = 2
I, [2013-11-08T18:17:34.821956 #20295]  INFO -- : Finished applying migration version 2, direction: up, took 0.001173 seconds
I, [2013-11-08T18:17:34.822098 #20295]  INFO -- : Begin applying migration version 3, direction: up
I, [2013-11-08T18:17:34.822478 #20295]  INFO -- : (0.000109s) PRAGMA foreign_keys
I, [2013-11-08T18:17:34.822705 #20295]  INFO -- : (0.000058s) PRAGMA foreign_keys = off
I, [2013-11-08T18:17:34.822943 #20295]  INFO -- : (0.000063s) BEGIN
I, [2013-11-08T18:17:34.823720 #20295]  INFO -- : (0.000466s) PRAGMA table_info('cats')
I, [2013-11-08T18:17:34.824062 #20295]  INFO -- : (0.000072s) PRAGMA foreign_key_list('cats')
E, [2013-11-08T18:17:34.824839 #20295] ERROR -- : SQLite3::SQLException: no such table: cats_backup0: SELECT NULL AS 'nil' FROM `cats_backup0` LIMIT 1
I, [2013-11-08T18:17:34.825615 #20295]  INFO -- : (0.000160s) PRAGMA index_list('cats')
I, [2013-11-08T18:17:34.826258 #20295]  INFO -- : (0.000471s) ALTER TABLE `cats` RENAME TO `cats_backup0`
I, [2013-11-08T18:17:34.826771 #20295]  INFO -- : (0.000353s) CREATE TABLE `cats`(`id` integer DEFAULT (NULL) NOT NULL PRIMARY KEY, `name` varchar(255) DEFAULT (NULL) NULL, `chip_id` varchar(255) DEFAULT (NULL) NOT NULL, `owner_name` varchar(255) DEFAULT (NULL) NULL, FOREIGN KEY (`owner_name`) REFERENCES `people`(`name`))
I, [2013-11-08T18:17:34.827055 #20295]  INFO -- : (0.000122s) INSERT INTO `cats`(`id`, `name`, `chip_id`, `owner_name`) SELECT `id`, `name`, `chip_id`, `owner_name` FROM `cats_backup0`
I, [2013-11-08T18:17:34.827471 #20295]  INFO -- : (0.000264s) DROP TABLE `cats_backup0`
I, [2013-11-08T18:17:34.827701 #20295]  INFO -- : (0.000077s) COMMIT
I, [2013-11-08T18:17:34.827937 #20295]  INFO -- : (0.000057s) PRAGMA foreign_keys = on
I, [2013-11-08T18:17:34.828319 #20295]  INFO -- : (0.000118s) UPDATE `schema_info` SET `version` = 3
I, [2013-11-08T18:17:34.828451 #20295]  INFO -- : Finished applying migration version 3, direction: up, took 0.006338 seconds

```
