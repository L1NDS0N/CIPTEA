import React, { useMemo, useState } from "react";
import { FiCamera, FiPaperclip } from "react-icons/fi";
import MaskedInput from "react-text-mask";

import ImageCropper from "../../components/ImageCropper";
import Modal from "../../components/Modal";
import NavigationButtons from "../../components/NavigationButtons";

import api from "../../services/api";
import "./styles.css";

export default function New({ history }) {
  const [nomeResponsavel, setNomeResponsavel] = useState("");
  const [cpfResponsavel, setCpfResponsavel] = useState("");
  const [rgResponsavel, setRgResponsavel] = useState("");
  const [nomeTitular, setNomeTitular] = useState("");
  const [cpfTitular, setCpfTitular] = useState("");
  const [rgTitular, setRgTitular] = useState("");
  const [dataNascimento, setDataNascimento] = useState("");
  const [sexoTitular, setSexoTitular] = useState("");
  const [emailContato, setEmailContato] = useState("");
  const [numeroContato, setNumeroContato] = useState("");
  const [fotoRostoPath, setFotoRostoPath] = useState(null);
  const [laudoMedicoPath, setLaudoMedicoPath] = useState(null);

  // Modal state
  const [isOpen, setIsOpen] = useState(false);

  async function quandoRecortado(fotoRecortada) {
    const imageBlob = fotoRecortada();
    setFotoRostoPath(imageBlob);
    setIsOpen(false);
  }

  // Não permitir outros formatos senão imagem
  const previewFotoRosto = useMemo(() => {
    return fotoRostoPath
      ? (setIsOpen(true), URL.createObjectURL(fotoRostoPath))
      : null;
  }, [fotoRostoPath]);

  const previewLaudoMedico = useMemo(() => {
    return laudoMedicoPath ? URL.createObjectURL(laudoMedicoPath) : null;
  }, [laudoMedicoPath]);

  async function handleSubmit(event) {
    const token = localStorage.getItem("userToken");
    event.preventDefault();

    const data = new FormData();
    data.append("nomeResponsavel", nomeResponsavel);
    data.append("cpfResponsavel", cpfResponsavel);
    data.append("rgResponsavel", rgResponsavel);
    data.append("nomeTitular", nomeTitular);
    data.append("cpfTitular", cpfTitular);
    data.append("rgTitular", rgTitular);
    data.append("dataNascimento", dataNascimento);
    data.append("sexoTitular", sexoTitular);
    data.append("emailContato", emailContato);
    data.append("numeroContato", numeroContato);
    data.append("fotoRostoPath", fotoRostoPath);
    data.append("laudoMedicoPath", laudoMedicoPath);

    await api.post("/carteiras", data, {
      headers: { Authorization: "Bearer " + token },
    });
    history.push("/");
  }
  return (
    <>
      <NavigationButtons />
      <form onSubmit={handleSubmit}>
        <label htmlFor="nomeResponsavel">Nome do responsável *</label>
        <input
          maxLength="250"
          required
          id="nomeResponsavel"
          placeholder="Insira o nome completo do responsável/tutor"
          value={nomeResponsavel}
          onChange={(event) => setNomeResponsavel(event.target.value)}
        />

        <label htmlFor="cpfResponsavel">CPF do responsável *</label>
        <MaskedInput
          mask={[
            /\d/,
            /\d/,
            /\d/,
            ".",
            /\d/,
            /\d/,
            /\d/,
            ".",
            /\d/,
            /\d/,
            /\d/,
            "-",
            /\d/,
            /\d/,
          ]}
          required
          guide={false}
          id="cpfResponsavel"
          placeholder="Insira o CPF do responsável/tutor"
          value={cpfResponsavel}
          onChange={(event) => setCpfResponsavel(event.target.value)}
        />

        <label htmlFor="rgResponsavel">RG do responsável *</label>
        <input
          maxLength="20"
          required
          id="rgResponsavel"
          placeholder="Insira o RG do responsável/tutor"
          value={rgResponsavel}
          onChange={(event) => setRgResponsavel(event.target.value)}
        />

        <label htmlFor="nomeTitular">Nome do titular *</label>
        <input
          maxLength="250"
          required
          id="nomeTitular"
          placeholder="Insira o nome completo do titular"
          value={nomeTitular}
          onChange={(event) => setNomeTitular(event.target.value)}
        />

        <label htmlFor="cpfTitular">CPF do titular *</label>
        <MaskedInput
          mask={[
            /\d/,
            /\d/,
            /\d/,
            ".",
            /\d/,
            /\d/,
            /\d/,
            ".",
            /\d/,
            /\d/,
            /\d/,
            "-",
            /\d/,
            /\d/,
          ]}
          required
          guide={false}
          id="cpfTitular"
          placeholder="Insira o CPF do titular"
          value={cpfTitular}
          onChange={(event) => setCpfTitular(event.target.value)}
        />

        <label htmlFor="rgTitular">RG do titular *</label>
        <input
          maxLength="20"
          required
          id="rgTitular"
          placeholder="Insira o RG do titular"
          value={rgTitular}
          onChange={(event) => setRgTitular(event.target.value)}
        />
        <div className="meio-a-meio">
          <label className="dataNascimento" htmlFor="dataNascimento">
            Data de nascimento *
          </label>
          <input
            type="date"
            required
            id="dataNascimento"
            placeholder="Insira a Data de Nascimento do Titular"
            value={dataNascimento}
            onChange={(event) => setDataNascimento(event.target.value)}
          />
          <label className="sexo" htmlFor="sexo">
            Sexo *
          </label>
          <select required id="sexo">
            <option select disabled selected="true">
              {" "}
              Selecione o sexo do Titular
            </option>
            <option
              value="Masculino"
              onChange={(event) => setSexoTitular(event.target.value)}
            >
              Masculino
            </option>
            <option
              value="Feminino"
              onChange={(event) => setSexoTitular(event.target.value)}
            >
              Feminino
            </option>
          </select>
        </div>
        <label htmlFor="emailContato">Email</label>
        <input
          type="emailContato"
          id="emailContato"
          placeholder="Insira um e-mail para contato"
          value={emailContato}
          onChange={(event) => setEmailContato(event.target.value)}
        />

        <label htmlFor="numeroContato">Telefone</label>
        <input
          type="numeroContato"
          id="numeroContato"
          placeholder="Insira um número de telefone para contato"
          value={numeroContato}
          onChange={(event) => setNumeroContato(event.target.value)}
        />

        <div className="anexosCadastro">
          <label
            htmlFor="previewFoto3x4"
            id="foto3x4"
            style={{ backgroundImage: `url(${previewFotoRosto})` }}
            className={fotoRostoPath ? "has-fotoRosto" : ""}
          >
            <span>Selecione a foto 3x4</span>
            <input
              id="previewFoto3x4"
              type="file"
              onChange={(event) => setFotoRostoPath(event.target.files[0])}
            />
            <div>
              <FiCamera size={30} alt="Selecione a foto 3x4" />
            </div>
          </label>

          <label
            htmlFor="previewLaudoMedico"
            id="laudoMedico"
            // style={{ backgroundImage: `url(${previewLaudoMedico})` }}
            className={laudoMedicoPath ? "has-laudoMedico" : ""}
          >
            <span>Selecione o laudo médico</span>
            <input
              id="previewLaudoMedico"
              type="file"
              onChange={(event) => setLaudoMedicoPath(event.target.files[0])}
            />
            <div>
              <FiPaperclip size={30} alt="Selecione o laudo médico" />
            </div>
            {laudoMedicoPath ? (
              <a
                className="pathLink"
                href={previewLaudoMedico}
                target="_blank"
                rel="noopener noreferrer"
              >
                <p title="Clique em volta para carregar outro arquivo">
                  <p className="nomeDoArquivo">{laudoMedicoPath.name}</p>
                  foi selecionado, clique aqui para visualizar em nova guia
                </p>
              </a>
            ) : (
              ""
            )}
          </label>
        </div>
        <button className="btn" type="submit">
          Cadastrar
        </button>
      </form>
      <Modal open={isOpen} onClose={() => setIsOpen(false)}>
        <ImageCropper
          src={previewFotoRosto}
          recorteCallback={quandoRecortado}
        ></ImageCropper>
      </Modal>
    </>
  );
}
