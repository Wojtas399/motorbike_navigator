abstract class Mapper<DomainModel, DtoModel> {
  DomainModel mapFromDto(DtoModel dto) {
    throw UnimplementedError();
  }
}
