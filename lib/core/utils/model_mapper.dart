abstract class ModelMapper<DomainModel, Dto>{

  Dto mapFromModel(DomainModel model);
  DomainModel mapToModel(Dto dto);

}