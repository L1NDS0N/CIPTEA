import React from 'react'

import './styles.css';
import { FiXSquare } from 'react-icons/fi';

export default function Modal({ open, children, onClose }) {
    if (!open) return null;

    return (
        <>
            <div className="modal-overlay" onClick={onClose}></div>
            <div className="modal-content">
                <FiXSquare size={26} className="modal-close" onClick={onClose}>Close Modal</FiXSquare>
                {children}
            </div>
        </>
    )
}