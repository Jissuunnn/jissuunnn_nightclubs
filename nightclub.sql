CREATE TABLE IF NOT EXISTS `nightclubs` (
    `owner` varchar(50) NOT NULL,
    `metadata` text NOT NULL,
    `missions` text NOT NULL,
    `employee` text NOT NULL,
    PRIMARY KEY (`owner`)
)