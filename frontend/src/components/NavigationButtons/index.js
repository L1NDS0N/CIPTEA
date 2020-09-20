import React from 'react';

import { FiArrowLeft, FiLogOut } from 'react-icons/fi'
import { withRouter } from 'react-router-dom';

import './styles.css'

function NavigationButtons({ history }) {
    return (
        <>
            <div className="NavigationButtons">
                <div className="ArrowLeft" onClick={() => history.goBack()}>
                    <FiArrowLeft className="ArrowLeftBtn" size={33} />
                </div>
                <div className="LogOut">
                    <FiLogOut className="LogOutBtn" size={33} />
                </div>
            </div>
        </>
    )
}

export default withRouter(NavigationButtons);