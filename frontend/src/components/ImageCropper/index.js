import React from 'react';
import Cropper from 'cropperjs';
import 'cropperjs/dist/cropper.min.css';
import './styles.css';

export default class ImageCropper extends React.Component {
    constructor() {
        super();
        this.state = {
            imageDestination: "",
            imageBlob: "",
            imageURL: "",
        }
        this.imageElement = React.createRef();
    }

    componentDidMount() {
        const cropper = new Cropper(this.imageElement.current, {
            zoomable: true,
            scalable: false,
            aspectRatio: 3 / 4,
            crop: async () => {
                const canvas = cropper.getCroppedCanvas();
                const base64Image = canvas.toDataURL("image/jpeg");
                this.setState({ imageDestination: base64Image });
                this.setState({ imageBlob: await fetch(base64Image).then((res) => res.blob()) });
                this.setState({ imageURL: URL.createObjectURL(this.state.imageBlob) })
            }
        });
    }

    render() {
        return (
            <>
                <div>
                    <div className="img-container">
                        <img ref={this.imageElement} src={this.props.src} alt="Foto original" />
                    </div>
                    <img className="img-preview" src={this.state.imageDestination} alt="Foto 3x4 acabada" />
                </div>
                <div>
                    {/* Essa eu preciso retornar na função */}
                    {/* <img src={this.state.imageURL} alt="Ota" /> */}
                </div>
            </>
        )
    }
}