import Cropper from "cropperjs";
import "cropperjs/dist/cropper.min.css";
import React from "react";
import "./styles.css";

export default class ImageCropper extends React.Component {
  constructor() {
    super();
    this.state = {
      imageDestination: "",
      imageBlob: "",
      imageURL: "",
    };
    // Isso resolveu o retorno undefined das props desta classe
    this.devolveRecortadoParaComponentePai =
      this.devolveRecortadoParaComponentePai.bind(this);
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
        const imageBlob = await fetch(base64Image).then((res) => res.blob());
        this.setState({
          imageDestination: base64Image,
          imageBlob,
        });
      },
    });
  }

  devolveRecortadoParaComponentePai() {
    this.props.recorteCallback(() => this.state.imageBlob);
  }

  render() {
    return (
      <>
        <div>
          <div className="img-container">
            <img
              ref={this.imageElement}
              src={this.props.src}
              alt="Foto original"
            />
          </div>
          <img
            className="img-preview"
            src={this.state.imageDestination}
            alt="Foto 3x4 acabada"
          />
        </div>
        <div>
          {/* Essa eu preciso retornar na função */}
          {/* <img src={this.state.imageURL} alt="Ota" /> */}
        </div>
        <footer className="cropper-footer">
          <button
            className="btn"
            onClick={this.devolveRecortadoParaComponentePai}
          >
            {" "}
            Recortar{" "}
          </button>
        </footer>
      </>
    );
  }
}
