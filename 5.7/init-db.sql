-- MySQL Script generated by MySQL Workbench
-- jeu. 12 janv. 2017 10:41:02 CET
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema workflow
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema workflow
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `workflow` DEFAULT CHARACTER SET utf8;
USE `workflow` ;

-- -----------------------------------------------------
-- Table `workflow`.`overlandjob`
-- -----------------------------------------------------
CREATE TABLE `overlandjob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_uid` varbinary(16) NOT NULL,
  `image_group` varchar(300) NOT NULL,
  `roadmap_type` int(11) NOT NULL,
  `roi` varchar(200) DEFAULT NULL,
  `created` datetime NOT NULL,
  `queued` datetime DEFAULT NULL,
  `started` datetime DEFAULT NULL,
  `done` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `workflow`.`notification_topic`
-- -----------------------------------------------------
CREATE TABLE `notification_topic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_uid` varbinary(16) NOT NULL,
  `topic` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `workflow`.`job`
-- -----------------------------------------------------
CREATE TABLE `job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT '0',
  `external_id` binary(16) NOT NULL,
  `roi` varchar(45) DEFAULT NULL,
  `sensor` varchar(45) DEFAULT NULL,
  `ovl_uuid` binary(16) NOT NULL,
  `launch_datetime` DATETIME NOT NULL,
  `finish_datetime` DATETIME NULL ,
  `start_period` varchar(45) NOT NULL,
  `end_period` varchar(45) NOT NULL,
  `models` varchar(45) NOT NULL,
  `ocs` varchar(45) NOT NULL,
  `depts` varchar(45) NOT NULL,
  `dump_path` varchar(255) NOT NULL,
  `export_type` varchar(45) NOT NULL,
  `security_coeff` varchar(45) NOT NULL,
  `classes` varchar(45) NOT NULL,
  `ut_threshold` decimal(20,10) NOT NULL,
  `surface_threshold` decimal(20,10) NOT NULL,
  `cell_weighting_threshold` decimal(20,10) NOT NULL,
  `q0_decades` int(11) NOT NULL,
  `q0_communes` int(11) NOT NULL,
  `bioprod_mobile_avg` int(11) NOT NULL,
  `bioprod_nbyears` int(11) NOT NULL,
  `db_ip` varchar(45) DEFAULT NULL,
  `db_password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`year` (
  `job_id` INT NOT NULL,
  `year` INT NOT NULL,
  `bioprod_status` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`job_id`, `year`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`decade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`decade` (
  `job_id` INT NOT NULL,
  `decade` INT NOT NULL,
  `year` INT NOT NULL,
  `disag_status` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`job_id`, `decade`, `year`),
  INDEX `fk_decade_1_idx` (`job_id` ASC, `year` ASC),
  CONSTRAINT `fk_decade_1`
    FOREIGN KEY (`job_id` , `year`)
    REFERENCES `workflow`.`year` (`job_id` , `year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`image` (
  `job_id` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `image_path` VARCHAR(256) NOT NULL,
  `decade` INT NOT NULL,
  `year` INT NOT NULL,
  `glcv_status` INT NOT NULL DEFAULT 0,
  `ovl_result_path` VARCHAR(256) NULL,
  PRIMARY KEY (`job_id`, `date`),
  INDEX `fk_image_2_idx` (`job_id` ASC),
  INDEX `fk_image_1_idx` (`job_id` ASC, `decade` ASC, `year` ASC),
  CONSTRAINT `fk_image_1`
    FOREIGN KEY (`job_id` , `decade` , `year`)
    REFERENCES `workflow`.`decade` (`job_id` , `decade` , `year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_image_2`
    FOREIGN KEY (`job_id`)
    REFERENCES `workflow`.`job` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`result` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `job_id` INT NOT NULL,
  `type` VARCHAR(10) NOT NULL,
  `url` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_result_1_idx` (`job_id` ASC),
  CONSTRAINT `fk_result_1`
    FOREIGN KEY (`job_id`)
    REFERENCES `workflow`.`job` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`ovl_scaling_job`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`ovl_scaling_job` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `workspace` VARCHAR(256) NOT NULL,
  `nb_roi` INT NOT NULL,
  `images` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`roi_process`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`roi_process` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `job_id` INT NOT NULL,
  `roi_name` VARCHAR(256) NOT NULL,
  `status` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_roi_process_1`
    FOREIGN KEY (`job_id`)
    REFERENCES `workflow`.`ovl_scaling_job` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `workflow`.`roi`
-- -----------------------------------------------------
CREATE TABLE `roi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `definition` text NOT NULL,
  `projection` varchar(80) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `workflow`.`harvester_config`
-- -----------------------------------------------------
CREATE TABLE `harvester_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roi_id` int(11) NOT NULL,
  `params` varchar(100) NOT NULL,
  `bucket` varchar(100) NOT NULL,
  `satellite` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `harvester_config_roi_id` (`roi_id`),
  CONSTRAINT `harvester_config_ibfk_1` FOREIGN KEY (`roi_id`) REFERENCES `roi` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `workflow`.`harvester_synchro`
-- -----------------------------------------------------
CREATE TABLE `harvester_synchro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `synchro_config_id` int(11) NOT NULL,
  `is_synchronized` tinyint(1) NOT NULL,
  `begin` datetime NOT NULL,
  `end` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `harvester_synchro_synchro_config_id` (`synchro_config_id`),
  CONSTRAINT `harvester_synchro_ibfk_1` FOREIGN KEY (`synchro_config_id`) REFERENCES `harvester_config` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `workflow`.`s10job`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workflow`.`s10job` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `job_uid` binary(16) NOT NULL,
  `year` VARCHAR(16) NOT NULL,
  `nut` VARCHAR(16) NOT NULL,
  `status` INT NOT NULL DEFAULT 0,
  `result_path` VARCHAR(256) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Insert France's ROI
-- -----------------------------------------------------
INSERT INTO roi(name, definition, projection) VALUES('france', '{"type":"Polygon","coordinates":[[[2.5927734375,51.248163159055906],[1.34033203125,50.999928855859636],[1.142578125,50.10648772767332],[-0.85693359375,49.63917719651036],[-2.109375,50.02185841773444],[-2.4169921874999996,49.63917719651036],[-1.9775390625,48.850258199721495],[-5.07568359375,49.023461463214126],[-5.5810546875,47.76886840424207],[-2.96630859375,46.84516443029276],[-1.6259765625,45.3521452458518],[-2.30712890625,43.03677585761058],[0.5712890625,42.19596877629178],[3.69140625,42.22851735620852],[3.8671874999999996,43.052833917627936],[6.8115234375,42.601619944327965],[9.03076171875,41.22824901518529],[9.84375,41.78769700539063],[9.64599609375,43.052833917627936],[7.62451171875,44.402391829093915],[7.14111328125,46.89023157359399],[8.1298828125,47.487513008956554],[8.85498046875,49.167338606291075],[2.5927734375,51.248163159055906]]]}', '3035');
INSERT INTO harvester_config (roi_id, params, bucket, satellite) VALUES(107, '{"collection":6}', 'ipp_harvester', 'modis');
INSERT INTO harvester_synchro (synchro_config_id, is_synchronized, begin, end) VALUES(70, true, '2019-01-01', '2019-05-24');

-- -----------------------------------------------------
-- Insert Brazil's ROI
-- -----------------------------------------------------
INSERT INTO roi(name, definition, projection) VALUES('brazil', '{"type":"Polygon","coordinates":[[[-49.21875,1.625758360412755],[-51.240234375,4.784468966579362],[-52.03125,4.258768357307995],[-52.91015625,2.8113711933311403],[-56.42578125,2.767477951092084],[-58.71093750000001,1.8014609294680355],[-59.6337890625,5.7908968128719565],[-61.8310546875,5.00339434502215],[-65.4345703125,4.696879026871425],[-64.9951171875,1.7136116598836224],[-67.060546875,2.7235830833483856],[-70.751953125,2.064982495867117],[-70.3564453125,-3.5572827265412794],[-73.47656249999999,-4.696879026871413],[-74.619140625,-7.580327791330129],[-73.5205078125,-10.055402736564224],[-70.927734375,-11.436955216143177],[-69.4775390625,-12.425847783029134],[-66.4892578125,-10.962764256386809],[-65.0390625,-12.940322128384613],[-61.083984375,-14.392118083661728],[-60.732421875,-16.93070509876553],[-59.150390625,-17.09879223767869],[-58.75488281249999,-23.120153621695614],[-56.51367187499999,-23.24134610238612],[-55.810546875,-24.806681353851978],[-54.66796875,-26.509904531413916],[-58.75488281249999,-30.145127183376115],[-54.4482421875,-32.916485347314385],[-53.5693359375,-34.56085936708384],[-47.0654296875,-28.1882436418503],[-47.63671875,-26.03704188651583],[-44.4287109375,-24.086589258228027],[-40.2978515625,-23.32208001137843],[-37.7490234375,-16.299051014581817],[-38.1005859375,-13.966054081318301],[-34.189453125,-8.537565350804018],[-34.892578125,-3.90809888189411],[-40.2978515625,-1.8893059628373186],[-49.1748046875,0.5712795966325395],[-49.21875,1.625758360412755]]]}', '3035');
INSERT INTO harvester_config (roi_id, params, bucket, satellite) VALUES(108, '{"collection":6}', 'ipp_harvester', 'modis');
INSERT INTO harvester_synchro (synchro_config_id, is_synchronized, begin, end) VALUES(71, false, '2001-01-01', '2001-12-31');

-- -----------------------------------------------------
-- Insert Italy's ROI
-- -----------------------------------------------------
INSERT INTO roi(name, definition, projection) VALUES('italy', '{"type": "Polygon","coordinates": [[[7.580566406250001,43.48481212891603],[8.98681640625,44.10336537791152],[9.865722656249998,43.70759350405294],[10.2392578125,43.14909399920127],[9.865722656249998,42.8115217450979],[10.08544921875,42.50450285299051],[10.65673828125,42.58544425738491],[12.28271484375,41.541477666790286],[10.0634765625,40.49709237269567],[9.4921875,41.31082388091818],[8.459472656249998,41.376808565702355],[7.8662109375,41.02964338716638],[8.020019531249998,38.90813299596705],[8.63525390625,38.54816542304656],[13.1396484375,40.863679665481676],[15.534667968749998,39.825413103424786],[15.710449218749998,38.8225909761771],[14.326171874999998,38.22091976683121],[13.46923828125,38.46219172306828],[12.216796875,38.272688535980976],[12.238769531249998,37.49229399862877],[14.326171874999998,36.54494944148322],[15.5126953125,36.43896124085945],[15.468749999999998,37.71859032558816],[16.083984375,37.68382032669382],[17.402343749999996,38.839707613545144],[17.314453125,39.52099229357195],[16.787109375,39.825413103424786],[17.11669921875,40.212440718286466],[18.34716796875,39.487084981687495],[18.852539062499996,40.06125658140474],[18.43505859375,40.66397287638688],[16.4794921875,41.47566020027821],[16.45751953125,42.09822241118974],[15.314941406249998,42.114523952464246],[13.974609375,43.59630591596548],[12.7001953125,44.308126684886126],[12.7880859375,44.77793589631623],[12.6123046875,45.259422036351694],[13.3154296875,45.537136680398596],[13.53515625,45.22848059584359],[14.1064453125,45.62940492064501],[13.86474609375,46.33175800051563],[14.0625,46.66451741754235],[12.568359375,46.9052455464292],[12.32666015625,47.29413372501023],[10.39306640625,46.98025235521883],[9.84375,46.5739667965278],[9.3603515625,46.70973594407157],[8.89892578125,46.28622391806706],[8.3056640625,46.649436163350245],[7.734374999999999,46.13417004624326],[6.74560546875,45.98169518512228],[6.35009765625,45.321254361171476],[6.50390625,44.512176171071054],[7.580566406250001,43.48481212891603]]]}', '3035');
INSERT INTO harvester_config (roi_id, params, bucket, satellite) VALUES(109, '{"collection":6}', 'ipp_harvester', 'modis');
INSERT INTO harvester_synchro (synchro_config_id, is_synchronized, begin, end) VALUES(72, false, '2017-11-01', '2018-10-31');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
