isDepot(data::Data, i::Int64) = i <= length(data.depots)

existsArc(data::Data, d::Int64, i::Int64, j::Int64) = data.costs[i, j] != -1 && (!isDepot(data, i) || i == d) && (!isDepot(data, j) || j == d)

arcs(data::Data) = ((d, i, j) for d in data.depots, i in data.vertices, j in data.vertices if existsArc(data, d, i, j))
arcs(data, d::Int64) = ((d, i, j) for i in data.vertices, j in data.vertices if existsArc(data, d, i, j))

taskArcs(data::Data) = ((d, i, j) for d in data.depots, i in data.tasks, j in data.tasks if existsArc(data, d, i, j))
taskArcs(data, d::Int64) = ((d, i, j) for i in data.tasks, j in data.tasks if existsArc(data, d, i, j))

arcsFrom(data::Data, i::Int64) = ((d, i, j) for d in data.depots, j in data.vertices if existsArc(data, d, i, j))
arcsFrom(data::Data, d::Int64, i::Int64) = ((d, i, j) for j in data.vertices if existsArc(data, d, i, j))

taskArcsFrom(data::Data, i::Int64) = ((d, i, j) for d in data.depots, j in data.tasks if existsArc(data, d, i, j))
taskArcsFrom(data::Data, d::Int64, i::Int64) = ((d, i, j) for j in data.tasks if existsArc(data, d, i, j))

arcsTo(data::Data, j::Int64) = ((d, i, j) for d in data.depots, i in data.vertices if existsArc(data, d, i, j))
arcsTo(data::Data, d::Int64, j::Int64) = ((d, i, j) for i in data.vertices if existsArc(data, d, i, j))

taskArcsTo(data::Data, j::Int64) = ((d, i, j) for d in data.depots, i in data.tasks if existsArc(data, d, i, j))
taskArcsTo(data::Data, d::Int64, j::Int64) = (i for i in data.tasks if existsArc(data, d, i, j))
