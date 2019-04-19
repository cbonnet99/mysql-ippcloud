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




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
