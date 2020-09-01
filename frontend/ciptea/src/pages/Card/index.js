import React, { useEffect, useState } from 'react';
import { FiPrinter, FiCornerLeftUp, FiChevronDown, FiUserCheck, FiMail, FiPhone } from 'react-icons/fi'
import { useParams } from 'react-router-dom'
import api from '../../services/api';

import './styles.css';


export default function Card(){
    
    const [carteira, setCarteira] = useState([]);
    const  { carteiraId }  = useParams();
    useEffect(() => {
        async function carregarCarteira(){
            const token = localStorage.getItem('userToken');
            const response = await api.get(`/carteiras/${carteiraId}`, {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setCarteira(response.data)
        }
        carregarCarteira();
    }, [carteiraId]);
    return (
        <>
            <ul className="carteira">
                   <li key={carteira.id}>                       
                       <header style={{ backgroundImage: `url(http://localhost:3333/files/${carteira.fotoRostoPath})`}} title="Foto de rosto, 3x4"></header>
                   </li>
                   <li>
                        <strong>{carteira.nomeTitular}</strong>
                        <span>{carteira.logradouro}, {carteira.numeroResidencia}, {carteira.complemento}, {carteira.bairro}, {carteira.cidade} - {carteira.uf} - {carteira.cep}.</span>
                        <br/>
                        <table>
                                <th colSpan="2"><FiUserCheck/> Informações para contato:</th>
                            <tr>
                                <td><FiMail /> E-mail:</td>
                                <td>{carteira.emailContato}</td>
                            </tr>
                            <tr>
                                <td><FiPhone /> Telefone:</td>
                                <td>{carteira.numeroContato}</td>
                            </tr>
                        </table>
                        
                   </li>
                   <li></li>
                        <button className="btn">
                            <FiCornerLeftUp size={14}/> Imprimir <FiPrinter size={14}/>
                        </button>        
                   
            </ul>
            <blockquote>

            <table>
                    <th><h2>#</h2></th>
                    <th><h2>Valor</h2></th>
                <tr>
                    <td>Nome do Titular</td>
                    <td>{carteira.nomeTitular}</td>
                </tr>
                <tr>
                    <td>CPF do Titular</td>
                    <td>{carteira.cpfTitular ? `${carteira.cpfTitular}` : `${carteira.rgTitular}`}</td>
                </tr>
                <tr>
                    <td>RG do Titular</td>
                    <td>{carteira.rgTitular}</td>                
                </tr>
                <tr>
                    <td>Data de Nascimento</td>
                <td>{carteira.dataNascimento}</td>                
                </tr>
                <tr>
                    <td>Nome do Responsável</td>
                    <td>{carteira.nomeResponsavel}</td>
                </tr>
                <tr>
                    <td>RG do Responsável</td>
                    <td>{carteira.rgResponsavel}</td>
                </tr>
                <tr>
                    <td>CPF do Responsável</td>
                    <td>{carteira.cpfResponsavel}</td>
                </tr>
            </table>
            </blockquote>
            <br/>

            <br/>
                <footer>
                    <tr>
                        <td>Data de criação: {carteira.created_at} </td>
                    </tr>
                    <tr>
                        <td>Última atualização em: {carteira.updated_at} </td>
                    </tr>
                </footer>
            <br/>
            
            <DropDown/>
        </>
    )
}

function DropDown(){
    const [open, setOpen] = useState(false);    
    return (
        <div className="dropdown">
            <nav className="DropDownMenu" onClick={() => setOpen(!open)}>Anexos <FiChevronDown size={20}/>
                <ul className="DropDown-Drop">
                    {/* <li className="DropDown-Item"></li> */}
                </ul>
            </nav>
        </div>
    )
}