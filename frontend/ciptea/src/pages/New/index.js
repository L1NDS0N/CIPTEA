import React, { useState, useMemo } from 'react';
import MaskedInput from 'react-text-mask';
import { FiCamera } from 'react-icons/fi';

import api from '../../services/api';
import './styles.css'

export default function New({ history }){
 const [nomeResponsavel, setNomeResponsavel] = useState('');
 const [cpfResponsavel, setCpfResponsavel] = useState('');
 const [rgResponsavel, setRgResponsavel] = useState('');
 const [nomeTitular, setNomeTitular] = useState('');
 const [cpfTitular, setCpfTitular] = useState('');
 const [rgTitular, setRgTitular] = useState('');
 const [dataNascimento, setDataNascimento] = useState('');
 const [emailContato, setEmailContato] = useState('');
 const [numeroContato, setNumeroContato] = useState('');
 const [fotoRosto, setFotoRosto] = useState(null);
    
const preview = useMemo(() => {
    return fotoRosto ? URL.createObjectURL(fotoRosto) : null;
}, [fotoRosto])

 async function handleSubmit(event){
    event.preventDefault();

    const token = localStorage.getItem('userToken');
    await api.post('/carteiras', {
        nomeResponsavel,
        cpfResponsavel,
        rgResponsavel,
        nomeTitular,
        cpfTitular,
        rgTitular,
        dataNascimento,
        emailContato,
        numeroContato,
        fotoRostoPath: fotoRosto },
        { headers: { 'Authorization': 'Bearer ' + token } }
    )
    history.push('/dashboard')
}
    return (
        <form onSubmit={handleSubmit}>
            <label htmlFor="nomeResponsavel">Nome do responsável *</label>
            <input 
                maxLength="250"
                required
                id="nomeResponsavel"
                placeholder="Insira o nome completo do responsável/tutor"
                value={nomeResponsavel}
                onChange={event => setNomeResponsavel(event.target.value)}
            />

            <label htmlFor="cpfResponsavel">CPF do responsável *</label>
            <MaskedInput
                mask={[/\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '-', /\d/, /\d/]}
                required
                guide={false}
                id="cpfResponsavel"
                placeholder="Insira o CPF do responsável/tutor"
                value={cpfResponsavel}
                onChange={event => setCpfResponsavel(event.target.value)}
            />

            <label htmlFor="rgResponsavel">RG do responsável *</label>
            <input
                maxLength="20"
                required
                id="rgResponsavel"
                placeholder="Insira o RG do responsável/tutor"
                value={rgResponsavel}
                onChange={event => setRgResponsavel(event.target.value)}
            />

            <label htmlFor="nomeTitular">Nome do titular *</label>
            <input 
                maxLength="250"
                required
                id="nomeTitular"
                placeholder="Insira o nome completo do titular"
                value={nomeTitular}
                onChange={event => setNomeTitular(event.target.value)}
            />

            <label htmlFor="cpfTitular">CPF do titular *</label>
            <MaskedInput
                mask={[/\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '-', /\d/, /\d/]}
                required
                guide={false}
                id="cpfTitular"
                placeholder="Insira o CPF do titular"
                value={cpfTitular}
                onChange={event => setCpfTitular(event.target.value)}
            />

            <label htmlFor="rgTitular">RG do titular *</label>
            <input
                maxLength="20"
                required
                id="rgTitular"
                placeholder="Insira o RG do titular"
                value={rgTitular}
                onChange={event => setRgTitular(event.target.value)}
            />

            <label htmlFor="dataNascimento">Data de nascimento *</label>
            <input
                type="date"
                required
                id="dataNascimento"
                placeholder="Insira a Data de Nascimento do Titular"
                value={dataNascimento}
                onChange={event => setDataNascimento(event.target.value)}
            />

            <label htmlFor="emailContato">Email</label>
            <input
                type="emailContato"                
                id="emailContato"
                placeholder="Insira um e-mail para contato"
                value={emailContato}
                onChange={event => setEmailContato(event.target.value)}
            />

            <label htmlFor="numeroContato">Telefone</label>
            <input
                type="numeroContato"
                id="numeroContato"
                placeholder="Insira um número de telefone para contato"
                value={numeroContato}
                onChange={event => setNumeroContato(event.target.value)}
            />

            <label 
                htmlFor="previewFoto3x4"
                id="foto3x4"
                style={{ backgroundImage: `url(${preview})`}}
                className={ fotoRosto ? 'has-fotoRosto' : '' }
            >
                <span>Selecione a foto 3x4</span>
                <input 
                    id="previewFoto3x4"
                    type="file"
                    onChange={event => setFotoRosto(event.target.files[0])}
                    />
                <div>
                    <FiCamera size={30} alt="Selecione a foto 3x4"/>
                </div>
            </label>

            {/* <MaskedInput
                mask={[/[1-9]/, /\d/, '.']}
                placeholder="teste"
                guide={false}
                id="cpf"
            /> */}
            
            <button className="btn" type="submit">Cadastrar</button>
        </form>
    )
}