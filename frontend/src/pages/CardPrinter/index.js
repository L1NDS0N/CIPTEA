import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom'
import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import api from '../../services/api';

import './styles.css';
import NavigationButtons from '../../components/NavigationButtons';
import frenteCiptea from '../../assets/frenteCiptea.png'
import fundoCiptea from '../../assets/fundoCiptea.png'

export default function Card() {

    const [dataFormatada, setDataFormatada] = useState([]);
    const [carteira, setCarteira] = useState([]);
    const { carteiraId } = useParams();


    useEffect(() => {
        async function carregarCarteira() {
            const token = localStorage.getItem('userToken');
            const response = await api.get(`/carteiras/${carteiraId}`, {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setCarteira(response.data);
            var str = response.data.created_at;
            var parts = str.slice().split(' ');
            var dateCpnt = parts[0] + "T";
            var timeCpnt = parts[1];
            var readyToISO = dateCpnt + timeCpnt;
            const formattedDate = format(
                parseISO(readyToISO),
                "dd' de 'MMMM' de 'yyyy'", { locale: ptBR }
            );
            setDataFormatada(formattedDate);
        }
        carregarCarteira();
    }, [carteiraId]);

    //   ____________________________________________________________________________________________________________
    return (
        <>
            <NavigationButtons></NavigationButtons>
            <card className="carteiras">
                <card className="frenteCarteira">
                    <img className="cardImg" src={frenteCiptea} alt={carteira.nomeTitular}/>
                    <campoFoto>
                        <img src={`${process.env.REACT_APP_API_URL}/files/${carteira.fotoRostoPath}`} alt="" />
                    </campoFoto>
                    <nomeTitular>{carteira.nomeTitular}</nomeTitular>
                    <nomeResponsavel>{carteira.nomeResponsavel}</nomeResponsavel>
                    <cpfTitular>{carteira.cpfTitular}</cpfTitular>
                    <rgTitular>{carteira.rgTitular}</rgTitular>
                    <dataNascimento>{carteira.dataNascimento}</dataNascimento>
                    <dataEmissao>{dataFormatada}</dataEmissao>
                    <card className="EspacoFoto"></card>
                </card>
                <card className="fundoCarteira">
                    <img className="cardImg" src={fundoCiptea} alt="" />
                </card>
            </card>
    <button className="btn" onClick={() => window.print()}>Imprimir a carteirinha de {carteira.nomeTitular}</button>
        </>
    )
}
