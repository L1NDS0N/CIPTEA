import React from 'react';
import Cropper from 'cropperjs';
import 'cropperjs/dist/cropper.min.css';
import './styles.css';

export default class ImageCropper extends React.Component {
    constructor() {
        super();
        this.state = {
            imageDestination: null,
        }

        this.imageElement = React.createRef();
    }

    componentDidMount() {
        const cropper = new Cropper(this.imageElement.current, {
            zoomable: true,
            scalable: false,
            aspectRatio: 3 / 4,
            crop: () => {
                const canvas = cropper.getCroppedCanvas().toDataURL("image/*");
                this.setState({ imageDestination: canvas.toDataURL("image/png") });
            }
        });
        console.log(cropper)
    }

    render() {
        return (
            <>
                <div>
                    <div className="imgcrp-container">
                        <img ref={this.imageElement} src={this.props.src} alt="Original" />
                    </div>
                    <img className="imgcrp-preview" src={this.state.imageDestination} alt="Imagem final" />
                </div>
            </>
        )
    }
}