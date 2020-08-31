import React from 'react';

import { FiArrowLeft, FiLogOut } from 'react-icons/fi'

export default function NavigationButtons({ history }){
    return (
        <>
            <div className="NavigationButtons">
                <div className="ArrowLeft"><FiArrowLeft size={33}/></div>
                <div className="LogOut"><FiLogOut size={33}/></div>
            </div>
        </>
    )
}
