class RideModel {
  String taxi_id,
      cartype,
      intialkm,
      intailrate,
      base_fare,
      time_cahrge,
      rate_per_km,
      image,
      serge,
      gst,
      catType,
      minFare,
      cancellation_charges;
  List surge_charge;
  String admin_commission;
  RideModel(
      this.taxi_id,
      this.cartype,
      this.intialkm,
      this.intailrate,
      this.base_fare,
      this.time_cahrge,
      this.rate_per_km,
      this.image,
      this.serge,
      this.gst,
      this.surge_charge,
      this.catType,
      this.minFare,
      this.cancellation_charges,
      this.admin_commission);
}
