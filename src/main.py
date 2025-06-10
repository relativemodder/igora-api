from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

import models
import schemas
import crud
from database import get_session

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Welcome to Igora Rental API"}

# Roles endpoints
@app.post("/roles/", response_model=schemas.Role)
async def create_role(role: schemas.RoleCreate, db: AsyncSession = Depends(get_session)):
    db_role = await crud.create_role(db, role)
    return db_role

@app.get("/roles/", response_model=List[schemas.Role])
async def read_roles(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    roles = await crud.get_roles(db, skip=skip, limit=limit)
    return roles

@app.get("/roles/{role_id}", response_model=schemas.Role)
async def read_role(role_id: int, db: AsyncSession = Depends(get_session)):
    db_role = await crud.get_role(db, role_id)
    if db_role is None:
        raise HTTPException(status_code=404, detail="Role not found")
    return db_role

# Users endpoints
@app.post("/users/", response_model=schemas.User)
async def create_user(user: schemas.UserCreate, db: AsyncSession = Depends(get_session)):
    db_user = await crud.get_user_by_login(db, user.login)
    if db_user:
        raise HTTPException(status_code=400, detail="Login already registered")
    created_user = await crud.create_user(db, user)
    return created_user

@app.get("/users/", response_model=List[schemas.User])
async def read_users(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    users = await crud.get_users(db, skip=skip, limit=limit)
    return users

@app.get("/users/{user_id}", response_model=schemas.User)
async def read_user(user_id: int, db: AsyncSession = Depends(get_session)):
    db_user = await crud.get_user(db, user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

# Clients endpoints
@app.post("/clients/", response_model=schemas.Client)
async def create_client(client: schemas.ClientCreate, db: AsyncSession = Depends(get_session)):
    created_client = await crud.create_client(db, client)
    return created_client

@app.get("/clients/", response_model=List[schemas.Client])
async def read_clients(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    clients = await crud.get_clients(db, skip=skip, limit=limit)
    return clients

@app.get("/clients/{client_id}", response_model=schemas.Client)
async def read_client(client_id: int, db: AsyncSession = Depends(get_session)):
    db_client = await crud.get_client(db, client_id)
    if db_client is None:
        raise HTTPException(status_code=404, detail="Client not found")
    return db_client

# Equipment Categories endpoints
@app.post("/equipment-categories/", response_model=schemas.EquipmentCategory)
async def create_equipment_category(category: schemas.EquipmentCategoryCreate, db: AsyncSession = Depends(get_session)):
    from crud import create_equipment_category
    created_category = await create_equipment_category(db, category)
    return created_category

@app.get("/equipment-categories/", response_model=List[schemas.EquipmentCategory])
async def read_equipment_categories(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    from crud import get_equipment_categories
    categories = await get_equipment_categories(db, skip=skip, limit=limit)
    return categories

@app.get("/equipment-categories/{category_id}", response_model=schemas.EquipmentCategory)
async def read_equipment_category(category_id: int, db: AsyncSession = Depends(get_session)):
    from crud import get_equipment_category
    db_category = await get_equipment_category(db, category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Equipment category not found")
    return db_category

# Equipment endpoints
@app.post("/equipment/", response_model=schemas.Equipment)
async def create_equipment(equipment: schemas.EquipmentCreate, db: AsyncSession = Depends(get_session)):
    from crud import create_equipment
    created_equipment = await create_equipment(db, equipment)
    return created_equipment

@app.get("/equipment/", response_model=List[schemas.Equipment])
async def read_equipment(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    from crud import get_equipment
    equipment_list = await get_equipment(db, skip=skip, limit=limit)
    return equipment_list

@app.get("/equipment/{equipment_id}", response_model=schemas.Equipment)
async def read_equipment_item(equipment_id: int, db: AsyncSession = Depends(get_session)):
    from crud import get_equipment_item
    db_equipment = await get_equipment_item(db, equipment_id)
    if db_equipment is None:
        raise HTTPException(status_code=404, detail="Equipment not found")
    return db_equipment

# Services endpoints
@app.post("/services/", response_model=schemas.Service)
async def create_service(service: schemas.ServiceCreate, db: AsyncSession = Depends(get_session)):
    from crud import create_service
    created_service = await create_service(db, service)
    return created_service

@app.get("/services/", response_model=List[schemas.Service])
async def read_services(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    from crud import get_services
    services = await get_services(db, skip=skip, limit=limit)
    return services

@app.get("/services/{service_id}", response_model=schemas.Service)
async def read_service(service_id: int, db: AsyncSession = Depends(get_session)):
    from crud import get_service
    db_service = await get_service(db, service_id)
    if db_service is None:
        raise HTTPException(status_code=404, detail="Service not found")
    return db_service

# Orders endpoints
@app.post("/orders/", response_model=schemas.Order)
async def create_order(order: schemas.OrderCreate, db: AsyncSession = Depends(get_session)):
    from crud import create_order
    created_order = await create_order(db, order)
    return created_order

@app.get("/orders/", response_model=List[schemas.Order])
async def read_orders(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_session)):
    from crud import get_orders
    orders = await get_orders(db, skip=skip, limit=limit)
    return orders

@app.get("/orders/{order_id}", response_model=schemas.Order)
async def read_order(order_id: int, db: AsyncSession = Depends(get_session)):
    from crud import get_order
    db_order = await get_order(db, order_id)
    if db_order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return db_order

