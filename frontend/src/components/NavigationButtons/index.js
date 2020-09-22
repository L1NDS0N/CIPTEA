import React from 'react';

import { FiArrowLeft, FiLogOut } from 'react-icons/fi'
import { withRouter } from 'react-router-dom';

import './styles.css'

function NavigationButtons({ history }) {
    return (
        <>
            <div className="NavigationButtons">
                <div className="ArrowLeft" title="Página anterior" onClick={() => history.goBack()}>
                    <FiArrowLeft className="ArrowLeftBtn" size={33} />
                </div>
                <div className="LogOut" title="Sair do sistema" onClick={handleLogout}>
                    <FiLogOut className="LogOutBtn" size={33} />
                </div>
            </div>
        </>
    )
    function handleLogout(){
        localStorage.removeItem('userToken');
        history.push('/');
    }
}

export default withRouter(NavigationButtons);