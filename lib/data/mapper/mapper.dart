abstract class Mapper<DomainModel, DtoModel> {
  const Mapper();

  DomainModel mapFromDto(DtoModel dto) {
    throw UnimplementedError();
  }

  DtoModel mapToDto(DomainModel object) {
    throw UnimplementedError();
  }
}
