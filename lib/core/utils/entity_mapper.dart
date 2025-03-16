abstract class EntityMapper <Entity, DomainModel>{

  DomainModel mapFromEntity(Entity entity);

  Entity mapToEntity(DomainModel model);

}