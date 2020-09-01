import React, { useEffect, useState } from 'react';
import { FiPrinter, FiList, FiCornerLeftUp, FiChevronDown, FiUserCheck, FiMail, FiPhone } from 'react-icons/fi'
import { useParams } from 'react-router-dom'
import { format, parseISO } from 'date-fns';
import { ptBR }  from 'date-fns/locale';

import api from '../../services/api';

import './styles.css';


export default function Card(){

    const [carteira, setCarteira] = useState([]);
    const [usuarioRecepcionista, setUsuarioRecepcionista] = useState([]);

    const [dataFormatada, setDataFormatada] = useState([]);
    const [dataCriacao, setDataCriacao] = useState([]);
    const  { carteiraId }  = useParams();

    
    useEffect(() => {
        async function carregarCarteira(){
            const token = localStorage.getItem('userToken');
            const response = await api.get(`/carteiras/${carteiraId}`, {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setCarteira(response.data);
            setUsuarioRecepcionista(response.data.usuarioRecepcionista);
            setDataCriacao(response.data.created_at);
            
            handleDateFormat();
        }

        async function handleDateFormat(){
            var str = dataCriacao.toString();
            var parts = str.slice().split(' ');            
            var dateCpnt = parts[0]+"T";
            var timeCpnt = parts[1];
            var readyToISO = dateCpnt + timeCpnt;
            const formattedDate = format(
                parseISO(readyToISO),
                "'Dia' dd 'de' MMMM' de 'yyyy', às 'HH:mm'h'", { locale: ptBR }
            );
            setDataFormatada(formattedDate);
        } 
        carregarCarteira();        
    }, [carteiraId, dataCriacao]);     
            
//   ____________________________________________________________________________________________________________
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
                    
            <th colSpan="2"><h2><FiList/> Ficha completa de {carteira.nomeTitular}</h2></th>
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
                     <td>Criado por: {usuarioRecepcionista.nomeCompleto} - {usuarioRecepcionista.matricula}</td>
                    </tr>
                    <tr>
                        <td>Data de criação: { dataFormatada } </td>                        
                    </tr>
                    <tr>
                        <td>Última atualização: { carteira.updated_at === carteira.created_at ? 'Nunca atualizado antes' : carteira.updated_at }</td>
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