from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
import models
import schemas
from typing import List, Optional

# Roles
async def get_role(db: AsyncSession, role_id: int) -> Optional[models.Role]:
    result = await db.execute(select(models.Role).where(models.Role.role_id == role_id))
    return result.scalars().first()

async def get_roles(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.Role]:
    result = await db.execute(select(models.Role).offset(skip).limit(limit))
    return result.scalars().all()

async def create_role(db: AsyncSession, role: schemas.RoleCreate) -> models.Role:
    db_role = models.Role(**role.dict())
    db.add(db_role)
    await db.commit()
    await db.refresh(db_role)
    return db_role

# Users
async def get_user(db: AsyncSession, user_id: int) -> Optional[models.User]:
    result = await db.execute(select(models.User).where(models.User.user_id == user_id))
    return result.scalars().first()

async def get_user_by_login(db: AsyncSession, login: str) -> Optional[models.User]:
    result = await db.execute(select(models.User).where(models.User.login == login))
    return result.scalars().first()

async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.User]:
    result = await db.execute(select(models.User).offset(skip).limit(limit))
    return result.scalars().all()

async def create_user(db: AsyncSession, user: schemas.UserCreate) -> models.User:
    db_user = models.User(
        login=user.login,
        password_hash=user.password,  # TODO: hash password properly
        first_name=user.first_name,
        last_name=user.last_name,
        middle_name=user.middle_name,
        role_id=user.role_id,
        photo_path=user.photo_path,
        is_active=user.is_active,
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

# Clients
async def get_client(db: AsyncSession, client_id: int) -> Optional[models.Client]:
    result = await db.execute(select(models.Client).where(models.Client.client_id == client_id))
    return result.scalars().first()

async def get_clients(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.Client]:
    result = await db.execute(select(models.Client).offset(skip).limit(limit))
    return result.scalars().all()

async def create_client(db: AsyncSession, client: schemas.ClientCreate) -> models.Client:
    db_client = models.Client(**client.dict())
    db.add(db_client)
    await db.commit()
    await db.refresh(db_client)
    return db_client

# Similar CRUD functions can be added for EquipmentCategory, Equipment, Service, Order, OrderService, EquipmentReturn, Consumable, ConsumableTransaction

# Equipment Categories
async def get_equipment_category(db: AsyncSession, category_id: int) -> Optional[models.EquipmentCategory]:
    result = await db.execute(select(models.EquipmentCategory).where(models.EquipmentCategory.category_id == category_id))
    return result.scalars().first()

async def get_equipment_categories(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.EquipmentCategory]:
    result = await db.execute(select(models.EquipmentCategory).offset(skip).limit(limit))
    return result.scalars().all()

async def create_equipment_category(db: AsyncSession, category: schemas.EquipmentCategoryCreate) -> models.EquipmentCategory:
    db_category = models.EquipmentCategory(**category.dict())
    db.add(db_category)
    await db.commit()
    await db.refresh(db_category)
    return db_category

# Equipment
async def get_equipment_item(db: AsyncSession, equipment_id: int) -> Optional[models.Equipment]:
    result = await db.execute(select(models.Equipment).where(models.Equipment.equipment_id == equipment_id))
    return result.scalars().first()

async def get_equipment(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.Equipment]:
    result = await db.execute(select(models.Equipment).offset(skip).limit(limit))
    return result.scalars().all()

async def create_equipment(db: AsyncSession, equipment: schemas.EquipmentCreate) -> models.Equipment:
    db_equipment = models.Equipment(**equipment.dict())
    db.add(db_equipment)
    await db.commit()
    await db.refresh(db_equipment)
    return db_equipment

# Services
async def get_service(db: AsyncSession, service_id: int) -> Optional[models.Service]:
    result = await db.execute(select(models.Service).where(models.Service.service_id == service_id))
    return result.scalars().first()

async def get_services(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.Service]:
    result = await db.execute(select(models.Service).offset(skip).limit(limit))
    return result.scalars().all()

async def create_service(db: AsyncSession, service: schemas.ServiceCreate) -> models.Service:
    db_service = models.Service(**service.dict())
    db.add(db_service)
    await db.commit()
    await db.refresh(db_service)
    return db_service

# Orders
async def get_order(db: AsyncSession, order_id: int) -> Optional[models.Order]:
    result = await db.execute(select(models.Order).where(models.Order.order_id == order_id))
    return result.scalars().first()

async def get_orders(db: AsyncSession, skip: int = 0, limit: int = 100) -> List[models.Order]:
    result = await db.execute(select(models.Order).offset(skip).limit(limit))
    return result.scalars().all()

async def create_order(db: AsyncSession, order: schemas.OrderCreate) -> models.Order:
    db_order = models.Order(**order.dict())
    db.add(db_order)
    await db.commit()
    await db.refresh(db_order)
    return db_order
