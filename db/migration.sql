-- ciptea.carteiraptea definition

CREATE TABLE `carteiraptea` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NomeResponsavel` varchar(80) NOT NULL,
  `CpfResponsavel` varchar(14) NOT NULL,
  `RgResponsavel` varchar(20) NOT NULL,
  `NomeTitular` varchar(80) NOT NULL,
  `CpfTitular` varchar(14) NOT NULL,
  `RgTitular` varchar(20) NOT NULL,
  `DataNascimento` date NOT NULL,
  `fotoRostoPath` varchar(254) DEFAULT NULL,
  `EmailContato` varchar(100) DEFAULT NULL,
  `NumeroContato` varchar(10) DEFAULT NULL,
  `CriadoEm` timestamp NOT NULL DEFAULT current_timestamp(),
  `AlteradoEm` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `CpfTitular` (`CpfTitular`)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8;


-- ciptea.usuario definition

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(254) NOT NULL,
  `criadoem` timestamp NULL DEFAULT current_timestamp(),
  `alteradoem` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_un` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;