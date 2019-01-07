class Device {

    public baseURL: string = 'mt://device/'

    info(): MTMessage {
        return new MTMessage(this.baseURL + 'info')
    }

}

